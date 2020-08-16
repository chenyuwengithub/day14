package com.xiaoshu.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.xiaoshu.config.util.ConfigUtil;
import com.xiaoshu.entity.Major;
import com.xiaoshu.entity.MajorVO;
import com.xiaoshu.entity.Operation;
import com.xiaoshu.entity.Student;
import com.xiaoshu.service.OperationService;
import com.xiaoshu.service.StudentService;
import com.xiaoshu.util.StringUtil;
import com.xiaoshu.util.TimeUtil;
import com.xiaoshu.util.WriterUtil;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

@Controller
@RequestMapping("student")
public class StudentController {

	@Autowired
	StudentService studentService;

	@Autowired
	private OperationService operationService;
	@Autowired
	JedisPool jedisPool;

	@RequestMapping("studentIndex")
	public String index(HttpServletRequest request, Integer menuid) throws Exception {

		// 先试试从redis获取，如果没有，再走mysql
		Jedis jedis = jedisPool.getResource();
		String majors = jedis.get("majors");
		if (majors == null) {
			// 获取到所有的专业
			List<Major> majorList = studentService.findMajor();
			request.setAttribute("roleList", majorList);
			
			// json字符串来存储数据，List集合，转变成json数据
			String jsonString = JSON.toJSONString(majorList);
			
			jedis.set("majors", jsonString);

		}else{
			// 将majors数据，存入到域中
			
			// 将stringjson字符串，转变成List集合
			List<Major> majorList = JSON.parseArray(majors, Major.class);
			request.setAttribute("roleList", majorList);
		}
		List<Operation> operationList = operationService.findOperationIdsByMenuid(menuid);
		request.setAttribute("operationList", operationList);
		return "student";
	}

	@RequestMapping(value = "studentList", method = RequestMethod.POST)
	public void studentList(HttpServletRequest request, Student student, HttpServletResponse response, String offset,
			String limit) throws Exception {
		try {
			Integer pageSize = StringUtil.isEmpty(limit) ? ConfigUtil.getPageSize() : Integer.parseInt(limit);
			Integer pageNum = (Integer.parseInt(offset) / pageSize) + 1;
			PageInfo<Student> userList = studentService.findStudentPage(student, pageNum, pageSize);

			JSONObject jsonObj = new JSONObject();
			jsonObj.put("total", userList.getTotal());
			jsonObj.put("rows", userList.getList());
			WriterUtil.write(response, jsonObj.toString());
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	// 新增或修改
	@RequestMapping("reserveStudent")
	public void reserveStudent(HttpServletRequest request, Student student, HttpServletResponse response) {
		Integer sid = student.getSid();
		// 由于前台可能不填写爱好，所以导致，hobby=null，导致js会报undefined
		String hobby = student.getHobby();
		if (hobby == null) {
			student.setHobby("");
		}

		JSONObject result = new JSONObject();
		try {
			if (sid != null) { // userId不为空 说明是修改
				// 判断用户名是否存在
				if (studentService.existStudentWithSname(student.getSname()) == null) { // 没有重复可以添加
					studentService.update(student);
					result.put("success", true);
				} else {
					result.put("success", true);
					result.put("errorMsg", "该姓名被使用");
				}
			} else { // 添加
				// 判断用户名是否存在
				if (studentService.existStudentWithSname(student.getSname()) == null) { // 没有重复可以添加
					studentService.add(student);
					result.put("success", true);
				} else {
					result.put("success", true);
					result.put("errorMsg", "该姓名被使用");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", true);
			result.put("errorMsg", "对不起，操作失败");
		}
		WriterUtil.write(response, result.toString());
	}

	@RequestMapping("deleteStudent")
	public void delUser(HttpServletRequest request, HttpServletResponse response) {
		JSONObject result = new JSONObject();
		try {
			String[] ids = request.getParameter("ids").split(",");
			for (String id : ids) {
				studentService.deleteStudent(Integer.parseInt(id));
			}
			result.put("success", true);
			result.put("delNums", ids.length);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("errorMsg", "对不起，删除失败");
		}
		WriterUtil.write(response, result.toString());
	}

	@RequestMapping("outStudent")
	public void outStudent(HttpServletResponse response) {
		JSONObject result = new JSONObject();
		try {
			// 导出到指定的excel文件中
			// WorkBook
			HSSFWorkbook wb = new HSSFWorkbook();
			// sheet
			HSSFSheet sheet = wb.createSheet();
			// row 标题行
			HSSFRow row0 = sheet.createRow(0);
			String[] title = { "学生编号", "学生姓名", "性别", "爱好", "生日", "专业" };
			for (int i = 0; i < title.length; i++) {
				row0.createCell(i).setCellValue(title[i]);
			}

			List<Student> list = studentService.findAll();

			// 将数据库中的数据，导出到excel中
			for (int i = 0; i < list.size(); i++) {
				Student student = list.get(i);
				HSSFRow row = sheet.createRow(i + 1);
				row.createCell(0).setCellValue(student.getSid());
				row.createCell(1).setCellValue(student.getSname());
				row.createCell(2).setCellValue(student.getSex());
				row.createCell(3).setCellValue(student.getHobby());

				// // 将Date类型，转换成String类型
				// SimpleDateFormat simpleDateFormat = new
				// SimpleDateFormat("yyyy-MM-dd");
				// String format =
				// simpleDateFormat.format(student.getBirthday());
				//

				row.createCell(4).setCellValue(TimeUtil.formatTime(student.getBirthday(), "yyyy-MM-dd"));
				row.createCell(5).setCellValue(student.getMajor().getManame());

			}

			// 回显
			OutputStream out = new FileOutputStream(new File("F://ssm-h1903c.xls"));

			wb.write(out);

			wb.close();
			out.close();

			result.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("errorMsg", "对不起，删除失败");
		}
		WriterUtil.write(response, result.toString());
	}

	@RequestMapping("inStudent")
	public void inStudent(HttpServletResponse response, MultipartFile file) {

		JSONObject result = new JSONObject();
		try {
			// 创建WorkBook ，通过WorBook对象，获取上传的文件的内容
			HSSFWorkbook wb = new HSSFWorkbook(file.getInputStream());
			// 读取sheet对象
			HSSFSheet sheet = wb.getSheetAt(0);
			// 读取行
			int lastRowNum = sheet.getLastRowNum();

			for (int i = 1; i < lastRowNum + 1; i++) {

				HSSFRow row = sheet.getRow(i);
				Student s = new Student();
				// 姓名读取到了
				String sname = row.getCell(1).getStringCellValue();
				s.setSname(sname);

				String sex = row.getCell(2).getStringCellValue();
				s.setSex(sex);

				String hobby = row.getCell(3).getStringCellValue();
				s.setHobby(hobby);

				// 需要将生日，从String转会Date
				String str = row.getCell(4).getStringCellValue();
				s.setBirthday(TimeUtil.ParseTime(str, "yyyy-MM-dd"));

				String maname = row.getCell(5).getStringCellValue();
				Integer maid = studentService.findID(maname);
				s.setMaid(maid);

				// 插入到数据库中
				studentService.add(s);

			}
			wb.close();
			result.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", true);
			result.put("errorMsg", "对不起，操作失败");
		}
		WriterUtil.write(response, result.toString());
	}

	@RequestMapping("addMajor")
	public void addMajor(Major major, HttpServletResponse response) {

		JSONObject result = new JSONObject();
		try {

			studentService.addMajor(major);
			
			// 清空数据库中的majors
			Jedis jedis = jedisPool.getResource();
			jedis.del("majors");
			

			result.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", true);
			result.put("errorMsg", "对不起，操作失败");
		}
		WriterUtil.write(response, result.toString());
	}

	@RequestMapping("zzStudent")
	public void zzStudent(HttpServletResponse response) {

		JSONObject result = new JSONObject();
		try {

			// 去数据库中进行查询 统计信息
			List<MajorVO> list = studentService.findMajorVO();

			result.put("list", list);
			result.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", true);
			result.put("errorMsg", "对不起，操作失败");
		}
		WriterUtil.write(response, result.toString());
	}

	
	
}
