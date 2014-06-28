<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	// �`�N�O�� request �ѼƦӤ��O�a�}��ѼơA�]���� getAttribute ��k�Ӥ��O getParameter
	String action = (String)request.getAttribute("action");

	String id = (String)request.getAttribute("id");
	String name = (String)request.getAttribute("name");
	String englishName = (String)request.getAttribute("englishName");
	String age = (String)request.getAttribute("age");
	String sex = (String)request.getAttribute("sex");
	String birthday = (String)request.getAttribute("birthday");
	String description = (String)request.getAttribute("description");
	
	// �O �W�[���� �٬O �קﭶ���A�U�夤�ھڦ��ܼư��������B�z
	boolean isEdit = "edit".equals(action);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%= isEdit ? "�ק�H�����" : "�s�W�H�����" %></title>
<style type="text/css">body, td{font-size:12px; }</style>
</head>
<body>

<script type="text/javascript" src="js/calendar.js"></script>

<form action="operatePerson.jsp" method="post">

<input type="hidden" name="action" value="<%= isEdit ? "save" : "add" %>">
<input type="hidden" name="id" value="<%= isEdit ? id : "" %>">

<fieldset>
	<legend><%= isEdit ? "�ק�H�����" : "�s�W�H�����" %></legend>
	<table align=center>
		<tr>
			<td>�m�W</td>
			<td><input type="text" name="name" value="<%= isEdit ? name : "" %>"/></td>
		</tr>
		<tr>
			<td>�^��W</td>
			<td><input type="text" name="englishName"  value="<%= isEdit ? englishName : "" %>"/></td>
		</tr>
		<tr>
			<td>�ʧO</td>
			<td>
				<input type="radio" name="sex" value="�k" id="sex_male" <%= isEdit&&"�k".equals(sex) ? "checked" : "" %> /><label for="sex_male">�k</label>
				<input type="radio" name="sex" value="�k" id="sex_female" <%= isEdit&&"�k".equals(sex) ? "checked" : "" %>/><label for="sex_female">�k</label>
			</td>
		</tr>
		<tr>
			<td>�~��</td>
			<td><input type="text" name="age" value="<%= isEdit ? age : "" %>" /></td>
		</tr>
		<tr>
			<td>�ͤ�</td>
			<td>
				<input type="text" name="birthday" onfocus="setday(birthday)" value="<%= isEdit ? birthday : "" %>"/>
				<img src="images/calendar.gif" onclick="setday(birthday);" />
			</td>
		</tr>
		<tr>
			<td>�y�z</td>
			<td><textarea name="description" ><%= isEdit ? description : "" %></textarea></td>
		</tr>
		<tr>
			<td></td>
			<td>
				<input type="submit" value="<%= isEdit ? "�x�s" : "�W�[�H����T" %>"/>
				<input type="button" value="�Ǧ^" onclick="history.go(-1); " />
			</td>
		</tr>
	</table>
</fieldset>
</form>


</body>
</html>