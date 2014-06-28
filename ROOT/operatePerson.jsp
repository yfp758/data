<%@ page language="java" pageEncoding="UTF-8"
	contentType="text/html;charset=UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<jsp:directive.page import="java.sql.ResultSet" />
<jsp:directive.page import="java.sql.SQLException" />
<jsp:directive.page import="java.sql.PreparedStatement"/>
<jsp:directive.page import="java.text.SimpleDateFormat"/>
<jsp:directive.page import="java.sql.Timestamp"/>
<jsp:directive.page import="java.sql.Date"/>
<%!
	/** SQL �Ȥ�����޸�(')�ݭn��Ƭ� \'  */
	public String forSQL(String sql){
		return sql.replace("'", "\\'");
	}
%>
<%
	request.setCharacterEncoding("UTF-8");

	String name = request.getParameter("name");
	String englishName = request.getParameter("englishName");
	String age = request.getParameter("age");
	String birthday = request.getParameter("birthday");
	String sex = request.getParameter("sex");
	String description = request.getParameter("description");
	
	String action = request.getParameter("action");

	if("add".equals(action)){

		// INSERT SQL �ԭz
		String sql = "INSERT INTO tb_person " +
					" ( name, english_name, " +
					"   age, sex, birthday,  " +
					"   description ) values " +
					" ( '" + forSQL(name) + "', '" + forSQL(englishName) + "', " +
					"   '" + age + "', '" + sex + "', '" + birthday + "', " +
					"   '" + forSQL(description) + "' ) " ;
		
		
		Connection conn = null;
		Statement stmt = null;
		int result = 0;
		
		try{
		
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(
							"jdbc:mysql://localhost:3306/databaseWeb?characterEncoding=UTF-8", 
							"root", 
							"admin");
		
			stmt = conn.createStatement();
			
			// �ϥ� Statement ���� SQL �ԭz
			result = stmt.executeUpdate(sql);
			
		}catch(SQLException e){
			out.println("����SQL\"" + sql + "\"�ɵo�ͨҥ~�G" + e.getMessage());
			return;
		}finally{
			if(stmt != null)	stmt.close();
			if(conn != null)	conn.close();
		}
		
		out.println("<html><style>body{font-size:12px; line-height:25px; }</style><body>");
		out.println(result + " ���O���Q�W�[���Ʈw���C");
		out.println("<a href='index.jsp'>�Ǧ^�H���C��</a>");
		
		// �N���檺 SQL �ԭz��X��Ȥ��
		out.println("<br/><br/>���檺 SQL �ԭz���G<br/>" + sql);
		
		return;
		
	}
	else if("del".equals(action)){
		
		// ���@�өΪ̦h�� ID ��
		String[] id = request.getParameterValues("id");
		if(id == null || id.length == 0){	out.println("�S���Ŀ�����");	return;	}
		
		String condition = "";
		
		for(int i=0; i<id.length; i++){
			if(i == 0)	condition = "" + id[i];
			else		condition += ", " + id[i];
		}
		
		String sql = "DELETE FROM tb_person WHERE id IN (" + condition + ") ";		
		
		Connection conn = null;
		Statement stmt = null;
		
		try{
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(
								"jdbc:mysql://localhost:3306/databaseWeb?characterEncoding=UTF-8", 
								"root", 
								"admin");
			
			stmt = conn.createStatement();
			
			// �ϥ� Statement ���� SQL �ԭz
			int result = stmt.executeUpdate(sql);
	
			out.println("<html><style>body{font-size:12px; line-height:25px; }</style><body>");
			out.println(result + " ���O���Q�R���C");
			out.println("<a href='index.jsp'>�Ǧ^�H���C��</a>");
			
			// �N���檺 SQL �ԭz��X��Ȥ��
			out.println("<br/><br/>���檺 SQL �ԭz���G<br/>" + sql);
			
		}catch(SQLException e){
			out.println("����SQL\"" + sql + "\"�ɵo�ͨҥ~�G" + e.getMessage());
			e.printStackTrace();
		}finally{
			if(stmt != null)	stmt.close();
			if(conn != null)	conn.close();
		}
	}
	else if("edit".equals(action)){
		
		String id = request.getParameter("id");
		String sql = "SELECT * FROM tb_person WHERE id = " + id;
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try{
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(
								"jdbc:mysql://localhost:3306/databaseWeb?characterEncoding=UTF-8", 
								"root", 
								"admin");
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
	
			if(rs.next()){
				// ���O�� �N�T���r�q�q��Ʈw�����X �x�s�� request ���A��ܨ� �קﭶ��
				request.setAttribute("id", rs.getString("id"));
				request.setAttribute("name", rs.getString("name"));
				request.setAttribute("englishName", rs.getString("english_name"));
				request.setAttribute("age", rs.getString("age"));
				request.setAttribute("sex", rs.getString("sex"));
				request.setAttribute("birthday", rs.getString("birthday"));
				request.setAttribute("description", rs.getString("description"));
				
				request.setAttribute("action", action);
				
				// ���קﭶ��
				request.getRequestDispatcher("addPerson.jsp").forward(request, response);
			}
			else{
				// �S�����
				out.println("�S����� id �� " + id + " ���O���C");
			}
		}catch(SQLException e){
			out.println("����SQL\"" + sql + "\"�ɵo�ͨҥ~�G" + e.getMessage());
			e.printStackTrace();
		}finally{
			if(rs != null)		rs.close();
			if(stmt != null)	stmt.close();
			if(conn != null)	conn.close();
		}
	}
	else if("save".equals(action)){
		
		String id = request.getParameter("id");
		
		String sql = "UPDATE tb_person SET " +
					" 	name = '" + forSQL(name) + "', " +
					" 	english_name = '" + forSQL(englishName) + "', " +
					" 	sex = '" + sex + "', " +
					"	age = '" + age + "', " +
					" 	birthday = '" + birthday + "', " +
					" 	description = '" + forSQL(description) + "' " +
					" WHERE id = " + id;
		
		Connection conn = null;
		Statement stmt = null;
		try{
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(
								"jdbc:mysql://localhost:3306/databaseWeb?characterEncoding=UTF-8", 
								"root", 
								"admin");
			
			stmt = conn.createStatement();
			
			// �ϥ� Statement ���� SQL �ԭz
			int result = stmt.executeUpdate(sql);
	
			out.println("<html><style>body{font-size:12px; line-height:25px; }</style><body>");
			
			if(result == 0)		out.println("�v�T�ƥج� 0, �ק異��. ");
			else	out.println(result + " ���O���Q�ק�C");
			
			out.println("<a href='index.jsp'>�Ǧ^�H���C��</a>");
			
			// �N���檺 SQL �ԭz��X��Ȥ��
			out.println("<br/><br/>���檺 SQL �ԭz���G<br/>" + sql);
			
		}catch(SQLException e){
			out.println("����SQL\"" + sql + "\"�ɵo�ͨҥ~�G" + e.getMessage());
			e.printStackTrace();
		}finally{
			if(stmt != null)	stmt.close();
			if(conn != null)	conn.close();
		}
	}
	else{
		String id = request.getParameter("id");
		String sql = "UPDATE tb_person SET name = ?, english_name = ?, sex = ?, age = ?, birthday = ?, description = ? WHERE id = ? ";
		
		Connection conn = null;
		PreparedStatement preStmt = null;
		
		try{
			DriverManager.registerDriver(new com.mysql.jdbc.Driver());
			conn = DriverManager.getConnection(
								"jdbc:mysql://localhost:3306/databaseWeb?characterEncoding=UTF-8", 
								"root", 
								"admin");
			
			preStmt = conn.prepareStatement(sql);
			preStmt.setString(1, name);
			preStmt.setString(2, englishName);
			preStmt.setString(3, sex);
			preStmt.setInt(4, Integer.parseInt(age));
			preStmt.setDate(5, new Date(new SimpleDateFormat("yyyy-MM-dd").parse(birthday).getTime()));
			preStmt.setString(6, description);
			preStmt.setInt(7, Integer.parseInt(id));
			
			// �ϥ� preStmt ���� SQL �ԭz
			int result = preStmt.executeUpdate(sql);
	
			out.println("<html><style>body{font-size:12px; line-height:25px; }</style><body>");
			
			if(result == 0)		out.println("�v�T�ƥج� 0, �ק異��. ");
			else	out.println(result + " ���O���Q�ק�C");
			
			out.println("<a href='index.jsp'>�Ǧ^�H���C��</a>");
			
			// �N���檺 SQL �ԭz��X��Ȥ��
			out.println("<br/><br/>���檺 SQL �ԭz���G<br/>" + sql);
			
		}catch(SQLException e){
			out.println("����SQL\"" + sql + "\"�ɵo�ͨҥ~�G" + e.getMessage());
			e.printStackTrace();
		}finally{
			if(preStmt != null)	preStmt.close();
			if(conn != null)	conn.close();
		}
	}

%>
