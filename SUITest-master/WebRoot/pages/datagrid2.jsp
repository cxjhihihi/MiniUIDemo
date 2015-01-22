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
		<div showCollapseButton="true">
			<div style="margin-left: 10px">

				<div style="width: 100%;">
					<div class="mini-toolbar" style="border-bottom: 0; padding: 2px;">
						<table style="width: 100%;">
							<tr>
								<td style="width: 100%;">
             <a class="mini-button" iconCls="icon-add" onclick="add()">增加</a>
                        <a class="mini-button" iconCls="icon-add" onclick="edit()">编辑</a>
                        <a class="mini-button" iconCls="icon-remove" onclick="remove()">删除</a>  
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
					style="width: 100%; height: 90%;"
					url="/SUITest/MiniUi/SearchEmployees.do" idField="id"
					multiSelect="true" allowResize="true" pagesize="20">
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
			</div>
			<script type="text/javascript">
        mini.parse();

        var grid = mini.get("datagrid1");
        grid.load();
        grid.sortBy("createtime", "desc");

        
        function add() {
            
            mini.open({
                url:"/SUITest/pages/EmployeeWindow.html",
                title: "新增员工", width: 600, height: 360,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    var data = { action: "new"};
                    iframe.contentWindow.SetData(data);
                },
                ondestroy: function (action) {

                   grid.reload();
                }
            });
        }
        function edit() {
         
            var row = grid.getSelected();
            if (row) {
                mini.open({
                    url:"/SUITest/pages/EmployeeWindow.html",
                    title: "编辑员工", width: 600, height: 360,
                    onload: function () {
                        var iframe = this.getIFrameEl();
                        var data = { action: "edit", id: row.id };
                        iframe.contentWindow.SetData(data);
                        
                    },
                    ondestroy: function (action) {
                        grid.reload();
                        
                    }
                });
                
            } else {
                alert("请选中一条记录");
            }
            
        }
        function remove() {
            
            var rows = grid.getSelecteds();
            if (rows.length > 0) {
                if (mini.confirm("确定删除选中记录？")) {
                    var ids = [];
                    for (var i = 0, l = rows.length; i < l; i++) {
                        var r = rows[i];
                        ids.push(r.id);
                    }
                    var id = ids.join(',');
                    grid.loading("操作中，请稍后......");
                    $.ajax({
                        url: "/SUITest/MiniUi/RemoveEmployees.do&id=" +id,
                        success: function (text) {
                            grid.reload();
                        },
                        error: function () {
                        }
                    });
                }
            } else {
                alert("请选中一条记录");
            }
        }
        function search() {
            var key = mini.get("key").getValue();
            grid.load({ key: key });
        }
        function onKeyEnter(e) {
            search();
        }
        /////////////////////////////////////////////////
        function onBirthdayRenderer(e) {
            var value = e.value;
            if (value) return mini.formatDate(value, 'yyyy-MM-dd');
            return "";
        }
        function onMarriedRenderer(e) {
            if (e.value == 1) return "是";
            else return "否";
        }
        var Genders = [{ id: 1, text: '男' }, { id: 2, text: '女'}];        
        function onGenderRenderer(e) {
            for (var i = 0, l = Genders.length; i < l; i++) {
                var g = Genders[i];
                if (g.id == e.value) return g.text;
            }
            return "";
        }
</script>
	</body>
</html>
