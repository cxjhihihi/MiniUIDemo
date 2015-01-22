<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>Hello MiniUI!</title>
		<meta http-equiv="Content-Type" content="text/javascript" />
		<!--jQuery js-->
		<script type="text/javascript" src="/SUITest/scripts/boot.js"></script>
	</head>
	<body>
	this is for test test1
		<div showCollapseButton="true">
			<div style="margin-left: 10px">

				<div style="width: 100%;">
					<div class="mini-toolbar" style="border-bottom: 0; padding: 2px;">
						<table style="width: 100%;">
							<tr>
								<td style="width: 100%;">
									<a class="mini-button" iconCls="icon-add" onclick=addRow();>增加</a>
									<a class="mini-button" iconCls="icon-add" onclick=removeRow();>编辑</a>
									<a class="mini-button" iconCls="icon-remove"
										onclick=removeRow();>删除</a>
									<a class="mini-button" iconCls="icon-save"
										onclick="saveData()">save</a>
								</td>
								<td style="white-space: nowrap;">
									<input id="key" class="mini-textbox" emptyText="请输入姓名"
										style="width: 150px;" onenter="onKeyEnter"/>
									<a class="mini-button" onclick=search();>查询</a>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div id="datagrid1" class="mini-datagrid"
					style="width: 100%; height: 60%;"
					url="/SUITest/MiniUi/SearchEmployees.do" idField="id"
					multiSelect="true" allowResize="true" pageSize="20" >
					<div property="columns" style="height: 100%">
						<div type="checkcolumn"></div>
						<div field="loginname" width="120" headerAlign="center"
							allowSort="true">
							员工帐号
						</div>
						<div field="name" width="120" headerAlign="center"
							allowSort="true">
							员工姓名
						</div>
						<div field="gender" width="100" allowSort="true"
							renderer="onGenderRenderer" align="center" headerAlign="center">
							性别
						</div>
						<div field="age" width="100" allowSort="true">
							年龄
						</div>
						<div field="birthday" width="100" allowSort="true"
							dateFormat="yyyy-MM-dd">
							出生日期
						</div>
						<div field="createtime" width="100" headerAlign="center"
							dateFormat="yyyy-MM-dd" allowSort="true">
							创建日期
						</div>
					</div>
				</div>
				<fieldset
					style="width: 100%; border: solid 1px #aaa; margin-top: 8px; position: relative;">
					<legend>
						员工详细信息
					</legend>
					<div id="editForm1" style="padding: 5px;">
						<input class="mini-hidden" name="id" />
						<table style="width: 100%;">
							<tr>
								<td style="width: 80px;">
									员工帐号：
								</td>
								<td style="width: 150px;">
									<input id="loginname" name="loginname" class="mini-textbox" />
								</td>
								<td style="width: 80px;">
									姓名：
								</td>
								<td style="width: 150px;">
									<input id="name" name="name" class="mini-textbox" />
								</td>
								<td style="width: 80px;">
									薪资：
								</td>
								<td style="width: 150px;">
									<input name="salary" class="mini-textbox" />
								</td>
							</tr>
							<tr>
								<td>
									性别：
								</td>
								<td>
									<input id="gender" name="gender" class="mini-combobox"
										data="Genders" />
								</td>
								<td>
									年龄：
								</td>
								<td>
									<input id="age" name="age" class="mini-spinner" minValue="0"
										maxValue="200" value="25" />
								</td>
								<td>
									出生日期：
								</td>
								<td>
									<input id="birthday" name="birthday" class="mini-datepicker" />
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<script type="text/javascript">
	var Genders = [ {
		id : 1,
		text : '男'
	}, {
		id : 2,
		text : '女'
	} ];

	mini.parse();

	var grid = mini.get("datagrid1");
	grid.load();

	//绑定表单
	var db = new mini.DataBinding();

	db.bindForm("editForm1", grid);

	///////////////////////////////////////////////////////
	function onGenderRenderer(e) {
		for ( var i = 0, l = Genders.length; i < l; i++) {
			var g = Genders[i];
			if (g.id == e.value)
				return g.text;
		}
		return "";
	}
	function search() {
		var key = mini.get("key").getValue();
		grid.load( {
			key : key
		});
	}

	//////////////////////////////////////////////////////
	function addRow() {
		var newRow = {
			name : "New Row"
		};
		grid.addRow(newRow, 0);

		grid.deselectAll();
		grid.select(newRow);
	}
	function removeRow() {
		var rows = grid.getSelecteds();
		if (rows.length > 0) {
			grid.removeRows(rows, true);
		}
	}
	function saveData() {
		var data = grid.getChanges();
		var json = mini.encode(data);
		grid.loading("保存中，请稍后......");
		$.ajax( {
			url : "/SUITest/MiniUi/SaveEmployees.do",
			data : {
				data : json
			},
			type : "post",
			success : function(text) {
				grid.reload();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert(jqXHR.responseText);
			}
		});
	}
</script>
	</body>
</html>
