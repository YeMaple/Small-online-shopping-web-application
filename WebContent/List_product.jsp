<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<% 
	String user = (String) session.getAttribute("user");
	String role = (String) session.getAttribute("role");
	String cart_id = (String)session.getAttribute("cart");
	if(user == null){
		//System.out.println("Redirect!!!!!!!!!!!");
		response.sendRedirect("Failure.jsp?failure="+"NotLogin");
	}else{
%>

<%-- Import the java.sql package --%>
<%@ page import="java.sql.*"%>
<%-- Open connection code --%>
<%
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs1 = null;
		ResultSet rs = null;

		try {
	    	// Registering Postgresql JDBC driver with the DriverManager
	    	Class.forName("org.postgresql.Driver");
	
	    	// Open a connection to the database using DriverManager
	    	conn = DriverManager.getConnection(
	        	"jdbc:postgresql://localhost/shopping_db?" +
	        	"user=postgres&password=postgres");
%>

<%-- Get categories list code --%>
<%
	// Create the statement
	Statement statement = conn.createStatement();
	// Use the created statement to SELECT
	// the student attributes FROM the Student table.
	rs1 = statement.executeQuery("SELECT * FROM category");
%>

<%-- -------- SELECT product info Code -------- --%>
<%
		String action = request.getParameter("action");
		// Check if an insertion is requested
		if (action != null && action.equals("search")) {
			// get the input
			String P_name = request.getParameter("P_name");
			String C_id = request.getParameter("Category_id");
			
			if(C_id.equalsIgnoreCase("0")){
				C_id = null;
			}
			// set possible sql string
			String sql_request = "SELECT p.*, c.name FROM product p, category c WHERE p.category_id = c.id AND p.status = 'existent'";
			String sql_and = " AND ";
			String sql_p_name = "lower(p.name) like '%";
			String sql_c_id = "p.category_id = ";
			
			// check conditions
			// if we have both name and category constraint
			if(P_name != null && C_id != null){
				P_name = P_name.toLowerCase();
				sql_request = sql_request + sql_and + sql_p_name + 
						P_name + "%'" + sql_and + sql_c_id + C_id;
				
			}
			// if we have category constraint
			else if(P_name != null){
				P_name = P_name.toLowerCase();
				sql_request = sql_request + sql_and + sql_p_name + P_name + "%'";
			}else if(C_id != null){
				sql_request = sql_request + sql_and + sql_c_id + C_id;
			}
			//System.out.println(sql_request);
		 	// Use the prepare statement to SELECT
			// the product match the given attributes FROM the product table.
			pstmt = conn.prepareStatement(sql_request);
		    
		    rs = pstmt.executeQuery();
		}
		
%>

<div>
	<div>
		<form action="Product_Browsing.jsp">
			<input type="hidden" name="action" value="search">
			<%
			String curr = request.getParameter("Category_id");
			int current_selection = 0;
			if (curr != null) {
				current_selection = Integer.parseInt(curr);
			}
			//System.out.println(current_selection);
			%>
			<select name="Category_id">
				<option value=0> all</option>
				<%
					while(rs1.next()){
						String C_name = rs1.getString("name");
						//System.out.println(rs1.getInt("id"));
						if (((int)rs1.getInt("id")) == current_selection) {
				%>
			    <option selected  value="<%= rs1.getInt("id") %>">
			        <%=C_name %>
			    </option>				
				<% 
						} else {
				%>
			    <option value="<%= rs1.getInt("id") %>">
			        <%=C_name %>
			    </option>
			    <%	
						}
					}
			    %>
			</select>
			<%
				String P_name = request.getParameter("P_name");
				if (P_name != null) {
			%>
			<input type="text" name="P_name" placeholder="Search product name here" value="<%=P_name%>">
			<%
				} else {
			%>
			<input type="text" name="P_name" placeholder="Search product name here" value="">				
			<%
				}
			%>
			<input type="submit" value="Search">
		</form>
	</div>
	<div>
		<table>
		    <tr>
		        <th>ID</th>
		        <th>Name</th>
		        <th>Category</th>
		        <th>SKU</th>
		        <th>Price</th>
		    </tr>
		    <%-- First load code --%>
		    <% 
		    	// First time load
		    	if(rs == null){
		    		// Use the created statement to SELECT
		    		// all product attributes FROM the product table.
		    		rs = statement.executeQuery("SELECT p.*, c.name FROM product p, category c WHERE p.category_id = c.id AND p.status = 'existent'");
		    	}
		    	int count = 0;
		    %>

		    <%-- Iteration code --%>
		    <%
		        while (rs.next()) {
		        	count++;
		    %>
		    <tr>
		            <%-- Get the id --%>
		            <td>
		                 <%=rs.getInt(1)%>
		            </td>
		            <%-- Get the name --%>
		            <td>
		                <input value="<%=rs.getString(2)%>" name="product_name" readonly/>
		            </td>
		            <%-- Get the category --%>
		            <td>
		                <input value="<%=rs.getString(7)%>" name="category_name" readonly/>
		            </td>
		             <%-- Get the sku --%>
		            <td>
		                <input value="<%=rs.getString(3)%>" name="sku" readonly/>
		            </td>  
		            <%-- Get the price --%>
		            <td>
		                <input value="<%=rs.getDouble(4)%>" name="price" readonly/>
		            </td>
		            <form action="Product_Order.jsp" method="POST">
			            <input type="hidden" name="action" value="add"/>
			            <input type="hidden" value="<%=rs.getInt(1)%>" name="id"/>
			            <input type="hidden" value="<%=rs.getDouble(4)%>" name="price"/>
			            <%-- Button --%>
			            <td><input type="submit" value="Add to cart"/></td>
			        </form>
		    </tr>
		    <%
		        	}
		    %>
		    
		    <%-- Check empty list --%>
		    <%
		    	if(count == 0){
		    %>
		    <tr>
		    	<td>None</td>
		    	<td>None</td>
		    	<td>None</td>
		    	<td>None</td>
		    </tr>
		    <%
		    	}
		    %>
		</table>
	</div>
</div>

<%-- -------- Close Connection Code -------- --%>
<%
		// Close the ResultSet
		rs1.close();
		rs.close();
	
		// Close the statement
		statement.close();
		// Close the Connection
		conn.close();
		} catch (SQLException e) {
			// Wrap the SQL exception in a runtime exception to propagate
			// it upwards
			throw new RuntimeException(e);
		}
		finally {
		// Release resources in a finally block in reverse-order of
		// their creation
		if (rs1 != null) {
			try {
				rs1.close();
			} catch (SQLException e) { } // Ignore
				rs1 = null;
		}
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) { } // Ignore
				rs = null;
		}
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (SQLException e) { } // Ignore
			pstmt = null;
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) { } // Ignore
				conn = null;
			}
		}
	}
%>
</body>
</html>