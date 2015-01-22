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
		<link href="/SUITest/scripts/demo.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
	 <h1>CellEdit 单元格编辑</h1>
<div class="mini-fit" >
    <div style="width:100%;">
        <div class="mini-toolbar" style="border-bottom:0;padding:0px;">
            <table style="width:100%;">
                <tr>
                    <td style="width:100%;">
                        <a class="mini-button" iconCls="icon-add" onclick="addRow()" plain="true">增加</a>
                        <a class="mini-button" iconCls="icon-remove" onclick="removeRow()" plain="true">删除</a>
                        <span class="separator"></span>
                        <a class="mini-button" iconCls="icon-save" onclick="saveData()" plain="true">保存</a>            
                    </td>
                    <td style="white-space:nowrap;">
                        <input id="key" class="mini-textbox" emptyText="请输入姓名" style="width:150px;" onenter="onKeyEnter"/>   
                        <a class="mini-button" onclick="search()">查询</a>
                    </td>
                </tr>
            </table>           
        </div>
    </div>
    <div id="datagrid1" class="mini-datagrid" style="width:100%;height:90%;" 
        url="../data/AjaxService.jsp?method=SearchEmployees" idField="id"
        allowResize="true" pageSize="20" 
        allowCellEdit="true" allowCellSelect="true" multiSelect="true" 
        editNextOnEnterKey="true" 
        
    >
        <div property="columns">
            <div type="indexcolumn"></div>
            <div type="checkcolumn"></div>
            <div field="loginname" allowResize="false" width="120" headerAlign="center" allowSort="true">员工帐号
                <input property="editor" class="mini-textbox" style="width:100%;" />
            </div>
            <div field="age" width="100" allowSort="true" >年龄
                <input property="editor" class="mini-spinner"  minValue="0" maxValue="200" value="25" style="width:100%;"/>
            </div>            
            <div name="birthday" field="birthday" width="100" allowSort="true" dateFormat="yyyy-MM-dd">出生日期
                <input property="editor" class="mini-datepicker" style="width:100%;"/>
            </div>    
            <div field="remarks" width="120" headerAlign="center" allowSort="true">备注
                <input property="editor" class="mini-textarea" style="width:100%;" minHeight="50"/>
            </div>
            <!--ComboBox：本地数据-->         
            <div type="comboboxcolumn" autoShowPopup="true" name="gender" field="gender" width="100" allowSort="true"  align="center" headerAlign="center">性别
                <input property="editor" class="mini-combobox" style="width:100%;" data="Genders" />                
            </div>                              
            <!--ComboBox：远程数据-->
            <div type="comboboxcolumn" field="country" width="100" headerAlign="center" >国家
                <input property="editor" class="mini-combobox" style="width:100%;" url="../data/countrys.txt" />                
            </div>   
            <div type="checkboxcolumn" field="married" trueValue="1" falseValue="0" width="60" headerAlign="center">婚否</div>            
        </div>
    </div>
    </div>
    <script type="text/javascript">

     
        var Genders = [{ id: 1, text: '男' }, { id: 2, text: '女'}];
        
        mini.parse();

        var grid = mini.get("datagrid1");
        grid.load();

        //////////////////////////////////////////////////////

        function search() {       
            var key = mini.get("key").getValue();
            grid.load({ key: key });
        }

        function onKeyEnter(e) {
            search();
        }

        function addRow() {          
            var newRow = { name: "New Row" };
            grid.addRow(newRow, 0);
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
            $.ajax({
                url: "/SUITest/MiniUi/SaveEmployees.do",
                data: { data: json },
                type: "post",
                success: function (text) {
                    grid.reload();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(jqXHR.responseText);
                }
            });
        }

    </script>
	
	</body>
</html>
