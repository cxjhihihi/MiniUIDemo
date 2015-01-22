package com.miniui.action.action;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import Test.StringUtil;

import com.opensymphony.xwork2.ActionSupport;

public class TestAction extends ActionSupport{
	public String Test(){
		//System.out.println("yes");
		return "/index.jsp";
	}
	public String  SearchEmployees() throws Exception
	{ 		
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
		//System.out.println("yes");
	    //查询条件
	    String key = request.getParameter("key");
	    //System.out.println("TestAction"+key);
	    //System.out.println(request.getParameter("pageIndex"));
	    //分页
	    int pageIndex = Integer.parseInt(request.getParameter("pageIndex"));
	    int pageSize = Integer.parseInt(request.getParameter("pageSize"));        
	    //字段排序
	    String sortField = request.getParameter("sortField");
	    String sortOrder = request.getParameter("sortOrder");
		
	    HashMap result = new Test.TestDB().SearchEmployees(key, pageIndex, pageSize, sortField, sortOrder);
	    String json = Test.JSON.Encode(result);
	    //System.out.println(json);
	    response.getWriter().write(json);
	    return null;
	}
	public String SaveEmployees() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    String json = request.getParameter("data");
	    ArrayList rows = (ArrayList)Test.JSON.Decode(json);

	    for(int i=0,l=rows.size(); i<l; i++){
	    	HashMap row = (HashMap)rows.get(i);
	  		  
			String id = row.get("id") != null ? row.get("id").toString() : "";
	        String state = row.get("_state") != null ? row.get("_state").toString() : "";
	        if(state.equals("added") || id.equals(""))	//新增：id为空，或_state为added
	        {
	            row.put("createtime", new Date());
	            new Test.TestDB().InsertEmployee(row);
	        }
	        else if (state.equals("removed") || state.equals("deleted"))
	        {
	            new Test.TestDB().DeleteEmployee(id);
	        }
	        else if (state.equals("modified") || state.equals(""))	//更新：_state为空，或modified
	        {
	            new Test.TestDB().UpdateEmployee(row);
	        }
	    }
	    return null;
	}
	public String  RemoveEmployees() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    String idStr = request.getParameter("id");       
	    if (StringUtil.isNullOrEmpty(idStr)) return null;
	    String[] ids = idStr.split(",");
	    for (int i = 0, l = ids.length; i < l; i++)
	    {
	        String id = ids[i]; 
	        new Test.TestDB().DeleteEmployee(id);
	    } 
	    return null;
	}
	public String  GetEmployee() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    String id = request.getParameter("id");
	    HashMap user = new Test.TestDB().GetEmployee(id);
	    String json = Test.JSON.Encode(user);
	    response.getWriter().write(json);
	    return null;
	}
	public String GetDepartments() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    ArrayList data = new Test.TestDB().GetDepartments();
	    String json = Test.JSON.Encode(data);
	    response.getWriter().write(json);
	    return null;
	}
	public String GetPositions() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    ArrayList data = new Test.TestDB().GetPositions();
	    String json = Test.JSON.Encode(data);
	    response.getWriter().write(json);
	    return null;
	}
	public String GetEducationals() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    ArrayList data = new Test.TestDB().GetEducationals();
	    String json = Test.JSON.Encode(data);
	    response.getWriter().write(json);
	    return null;
	}
	public String  GetPositionsByDepartmenId() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    String id = request.getParameter("id");
	    ArrayList data = new Test.TestDB().GetPositionsByDepartmenId(id);
	    String json = Test.JSON.Encode(data);
	    response.getWriter().write(json);
	    return null;
	}

	public String  GetDepartmentEmployees() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    String dept_id = request.getParameter("dept_id");
	    int pageIndex = Integer.parseInt(request.getParameter("pageIndex"));
	    int pageSize = Integer.parseInt(request.getParameter("pageSize"));

	    HashMap result = new Test.TestDB().GetDepartmentEmployees(dept_id, pageIndex, pageSize);
	    String json = Test.JSON.Encode(result);
	    response.getWriter().write(json);
	    return null;
	}


	public String  SaveDepartment() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    String departmentsStr = request.getParameter("departments");
	    
	    ArrayList departments = (ArrayList)Test.JSON.Decode(departmentsStr);
	    
	    for(int i=0,l=departments.size(); i<l; i++){
	    	HashMap d = (HashMap)departments.get(i);  		
	    	new Test.TestDB().UpdateDepartment(d);
	    }
	    return null;
	}

	/////////////////////////////
	public String  FilterCountrys() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    String key = request.getParameter("key");
	    String value = request.getParameter("value");
		
	    //建立value的快速哈希索引，便于快速判断是否已经选择
	    String[] values = value.split(",");
	    HashMap valueMap = new HashMap();
	    for(int i=0,l=values.length; i<l; i++){
	        String id = values[i];
	        valueMap.put(id, "1");
	    }

	    //获取数据 
	    String path = request.getSession().getServletContext().getRealPath("/");    
	    
	    
	    String file = path + "/demo/data/countrys.txt";
	    String s = Test.File.read(file);
	    ArrayList data = (ArrayList)Test.JSON.Decode(s);

	    //1）去除已经选择的记录
	    for (int i = data.size() - 1; i >= 0; i--)
	    {
	        HashMap o = (HashMap)data.get(i);
	        String id = o.get("id").toString();
	        if (valueMap.get(id) != null)
	        {
	            data.remove(i);
	        }
	    }


	    //2）根据名称查找
	    ArrayList result = new ArrayList();
	    for (int i = 0, l = data.size(); i < l; i++)
	    {
	        HashMap o = (HashMap)data.get(i);
	        String text = o.get("text").toString();
	        if (StringUtil.isNullOrEmpty(key) || text.toLowerCase().indexOf(key.toLowerCase()) != -1)
	        {
	            result.add(o);
	        }
	    }

	    //返回JSON数据
	    String json = Test.JSON.Encode(result);
	    response.getWriter().write(json);
	    return null;
	}
	public String  FilterCountrys2() throws Exception
	{
		HttpServletRequest request =ServletActionContext.getRequest();
		HttpServletResponse response = ServletActionContext.getResponse();
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    String key = request.getParameter("key");
	    String value = request.getParameter("value");
		
	    //获取数据 
	    String path = request.getSession().getServletContext().getRealPath("/");    
	    
	    
	    String file = path + "/demo/data/countrys.txt";
	    String s = Test.File.read(file);
	    ArrayList data = (ArrayList)Test.JSON.Decode(s);


	    //根据名称查找
	    ArrayList result = new ArrayList();
	    for (int i = 0, l = data.size(); i < l; i++)
	    {
	        HashMap o = (HashMap)data.get(i);
	        String text = o.get("text").toString();
	        if (StringUtil.isNullOrEmpty(key) || text.toLowerCase().indexOf(key.toLowerCase()) != -1)
	        {
	            result.add(o);
	        }
	    }

	    //返回JSON数据
	    String json = Test.JSON.Encode(result);
	    response.getWriter().write(json);
		return null;
	}


}
