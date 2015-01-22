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
		<title>Test for CXJ</title>
		<meta http-equiv="Content-Type" content="text/javascript" />
		<!--jQuery js-->
		<link href="/SUITest/scripts/demo.css" rel="stylesheet"
			type="text/css" />
		<script type="text/javascript" src="/SUITest/scripts/boot.js"></script>
		<style type="text/css">
			body {
				margin: 0;
				padding: 0;
				border: 0;
				width: 100%;
				height: 100%;
				overflow:hidden;
			}

			.header {
				background:
					url(/SUITest/scripts/miniui/themes/blue/images/calendar/sui_logo.gif)
					repeat-y;
			}
			
			.p_ep_topbg {
				background: #585858
					url(/SUITest/scripts/miniui/themes/blue/images/calendar/sui_top_bg.gif)
					repeat-x left top;
			}
			
			.p_ep_head {
				height: 86px;
				margin: 0 auto;
			}
		</style>
	</head>
	<body>
		<div style="height: 100%">
			<div class="p_ep_topbg" style="height: 13%">
				<div class="p_ep_head" style="height: 100%">
					<div class="header" region="north" style="height: 100%"
						showSplit="false" showHeader="false">
						 <div style="position:absolute;top:18px;right:10px;">
				            <a class="mini-button mini-button-iconTop" iconCls="icon-add" onclick="" plain="true">快捷</a>    
				            <a class="mini-button mini-button-iconTop" iconCls="icon-edit" onclick=""  plain="true" >首页</a>        
				            <a class="mini-button mini-button-iconTop" iconCls="icon-date" onclick=""  plain="true" >消息</a>        
				            <a class="mini-button mini-button-iconTop" iconCls="icon-edit" onclick=""  plain="true" >设置</a>        
				            <a class="mini-button mini-button-iconTop" iconCls="icon-close" onclick="closeit()"  plain="true" >关闭</a>        
        				 </div>				
					</div>	
				</div>
			</div>
			<div class="mini-splitter"
				style="width: 100%; height: 85%; margin-top: 3px">
				<div size="20%" showCollapseButton="true">
					<div id="outlookbar1" class="mini-outlookbar " activeIndex="0"
						style="width: 100%; height: 100%;" autoCollapse="true">
						<div title="权限管理">
							<!--Tree-->
							<ul id="tree1" class="mini-tree" url="data/listTree.txt"
								style="width: 100%; height: 100%;" showTreeIcon="true"
								textField="text" idField="id" resultAsTree="false"
								onnodeselect="onNodeSelect">
							</ul>
						</div>
						<div title="用户管理">
							2
						</div>
					</div>
				</div>
				<div showCollapseButton="false" style="border: 0px; width: 75%">
					<!--Tabs-->
					<div id="mainTabs" class="mini-tabs" activeIndex="0"
						style="width: 100%; height: 100%;" contextMenu="#tabsMenu">
						<div title="首页" url="pages/datagrid.jsp">
						</div>
					</div>
				</div>
			
			</div>
		</div>
		<ul id="tabsMenu" class="mini-contextmenu" onbeforeopen="onBeforeOpen">        
        	<li onclick="closeTab">关闭标签页</li>                
	    	<li onclick="closeAllBut">关闭其他标签页</li>
	    	<li onclick="closeAll">关闭所有标签页</li>        
    	</ul>
		<script type="text/javascript">

			mini.parse();
			var tabs = mini.get("mainTabs");
			var currentTab = null;
			function showTab(node) {

		
				var id = "tab$" + node.id;
				var tab = tabs.getTab(id);
				if (!tab) {
					tab = {};
					tab.name = id;
					tab.title = node.text;
					tab.showCloseButton = true;
		
					//这里拼接了url，实际项目，应该从后台直接获得完整的url地址
					tab.url = "/SUITest/pages/" + node.id + ".jsp";
		
					tabs.addTab(tab);
				}
				tabs.activeTab(tab);
			}
		 	 function onBeforeOpen(e) {
            	currentTab = tabs.getTabByEvent(e.htmlEvent);
            		if (!currentTab) {
                		e.cancel = true;                
            		}
        	}

	        ///////////////////////////
	        function closeTab() {
	            tabs.removeTab(currentTab);
	        }
	        function closeAllBut() {
	            tabs.removeAll(currentTab);
	        }
	        function closeAll() {
	            tabs.removeAll();
	        }
			function onNodeSelect(e) {
		
				var node = e.node;
				var isLeaf = e.isLeaf;
		
				if (isLeaf) {
					showTab(node);
				}
			}
		
			function closeit() {
				mini.confirm("确认关闭吗？", "关闭", function() {
					var href = "http://www.baidu.com";
					window.open(href, "_self", "");
					window.close();
				});
			}
		</script>
	</body>
</html>
