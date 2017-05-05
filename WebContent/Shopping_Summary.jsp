<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Shopping Cart Summary</title>
</head>
<body>
<%-- Import the java.sql package --%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%-- Open connection code --%>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	
	int cart_id = Integer.parseInt((String) session.getAttribute("cart"));
	String action = request.getParameter("action");

	try {
		/*
	    // Registering Postgresql JDBC driver with the DriverManager
	    Class.forName("org.postgresql.Driver");
	
	    // Open a connection to the database using DriverManager
	    conn = DriverManager.getConnection(
	        	"jdbc:postgresql://localhost/shopping_db?" +
	        	"user=postgres&password=postgres");
	    */
		// Obtain the environment naming context
        Context initCtx = new InitialContext();
        // Look up the data source
        DataSource ds = (DataSource) initCtx.lookup("java:comp/env/jdbc/ShoppingDBPool");
        // Allocate and use a connection from the pool
        conn = ds.getConnection();
%>


<%-- Select code --%>
<%
		// Search the shopping cart content
		pstmt = 
		conn.prepareStatement(
		"SELECT p.id, p.name, p.sku, c.added_price, c.quantity " +
		"FROM Product p, Contains c " +
		"WHERE c.cart_id = ? AND c.product_id = p.id");
		pstmt.setInt(1, cart_id);
		rs = pstmt.executeQuery();
		
		// Calculate the shopping cart price
		pstmt = 
		conn.prepareStatement(
		"SELECT SUM(c.added_price * c.quantity) " +
		"FROM Product p, Contains c " +
		"WHERE c.cart_id = ? AND c.product_id = p.id");
		pstmt.setInt(1, cart_id);
		rs1 = pstmt.executeQuery();
%>

<div>
	<div>
		<table>
		    <tr>
		        <th>ID</th>
				<th>Name</th>
				<th>SKU</th>
				<th>Price</th>
				<th>Quantity</th>
		    </tr>

		    <%-- Iteration code --%>
		    <%
		    	int count = 0;
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
		            <%-- Get the sku --%>
		            <td>
		                <input value="<%=rs.getString(3)%>" name="product_price" readonly/>
		            </td>
		             <%-- Get the price --%>
		            <td>
		                <input value="<%=rs.getDouble(4)%>" name="product_quantity" readonly/>
		            </td>
		            <%-- Get the quantity --%>
		            <td>
		                <input value="<%=rs.getInt(5)%>" name="product_quantity" readonly/>
		            </td>
		    </tr>
		    <%
		        	}
		        if(rs1.next()){
		    %>
		    <tr>
		    	Total Price: $<%= rs1.getDouble(1) %>
		    </tr>
		    <%-- Check empty list --%>
		    <%
		        }else{
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
	<div>
		<%-- Credit card information --%>
		<form action="Confirmation.jsp" method = "POST">
			<input type="hidden" name="action" value="purchase"/>
			Please enter your credit card information<p>
			<input value="" name="credit_card_name" required>
			<input type="submit" value="Purchase"/>
		</form>
	</div>
</div>

<%-- -------- Close Connection Code -------- --%>
<%
		// Close the ResultSet
		rs.close();
		rs1.close();

		// Close the Connection
		conn.close();
		
		} catch (SQLException e) {
			// Wrap the SQL exception in a runtime exception to propagate
			// it upwards
			//throw new RuntimeException(e);
			response.sendRedirect("Failure.jsp?failure="+"Other");
		} catch (Exception e) {
			response.sendRedirect("Failure.jsp?failure="+"Other");
		}
		finally {
		// Release resources in a finally block in reverse-order of
		// their creation
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) { } // Ignore
				rs = null;
		}
		if (rs1 != null) {
			try {
				rs1.close();
			} catch (SQLException e) { } // Ignore
				rs1 = null;
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
%>
<form action="Product_Browsing.jsp">
	<button>Return to product browsing</button>
</form>

</body>
</html>