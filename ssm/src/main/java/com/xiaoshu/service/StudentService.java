package com.xiaoshu.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.xiaoshu.dao.MajorMapper;
import com.xiaoshu.dao.StudentMapper;
import com.xiaoshu.entity.Major;
import com.xiaoshu.entity.MajorVO;
import com.xiaoshu.entity.Student;
import com.xiaoshu.entity.User;
import com.xiaoshu.entity.UserExample;
import com.xiaoshu.entity.UserExample.Criteria;

@Service
@Transactional
public class StudentService {

	@Autowired
	MajorMapper majorMapper;
	
	@Autowired
	StudentMapper studentMapper;
	
	public List<Major> findMajor() {
		return majorMapper.selectAll();
	}

	public PageInfo<Student> findStudentPage(Student student, int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		
		List<Student> userList = studentMapper.findAll(student);
		
		PageInfo<Student> pageInfo = new PageInfo<Student>(userList);
		return pageInfo;
	}
	public List<Student> findAll(){

		List<Student> userList = studentMapper.findAll(null);
		
		return userList;
	}
	
	// 通过姓名判断是否存在，（新增时不能重名）
	public Student existStudentWithSname(String sname) throws Exception {
		// 去数据库查找是否存在，此姓名
		List<Student> userList = studentMapper.findStudentBySname(sname);
		return userList.isEmpty()?null:userList.get(0);
	}

	public void add(Student student) {
		studentMapper.insert(student);
	}

	public void deleteStudent(int id) {
		studentMapper.deleteByPrimaryKey(id);
	}

	public void update(Student student) {
		studentMapper.updateByPrimaryKey(student);
	}

	public Integer findID(String maname) {
		return majorMapper.findID(maname);
	}

	public void addMajor(Major major) {
		majorMapper.insert(major);
	}

	public List<MajorVO> findMajorVO() {
		return studentMapper.findMajorVO();
	};
	
}
