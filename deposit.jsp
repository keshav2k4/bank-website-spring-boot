<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Deposit</title>
    <style>
          .navbar {
            list-style: none;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            overflow: hidden;
            border-bottom: 1px solid #ccc;
          }
          .navbar li {
            display: inline-block;
            padding: 10px;
          }
          .navbar a {
            text-decoration: none;
            color: #333;
          }
          .navbar a:hover {
            color: #007bff;
        }
        /* Additional CSS */
        .deposit-form {
          max-width: 400px;
          margin: 20px auto;
          padding: 20px;
          border: 1px solid #ccc;
          border-radius: 5px;
          background-color: #f9f9f9;
        }
        .deposit-form label {
          display: block;
          margin-bottom: 10px;
        }
        .deposit-form input[type="number"] {
          width: 100%;
          padding: 8px;
          border: 1px solid #ccc;
          border-radius: 4px;
          box-sizing: border-box;
          margin-bottom: 15px;
        }
        .deposit-form button[type="submit"] {
          background-color: #007bff;
          color: #fff;
          padding: 10px 20px;
          border: none;
          border-radius: 4px;
          cursor: pointer;
        }
        .deposit-form button[type="submit"]:hover {
          background-color: #0056b3;
        }
        .message {
          margin-top: 20px;
          padding: 10px;
          border-radius: 4px;
        }
        .message.success {
          background-color: #d4edda;
          color: #155724;
          border: 1px solid #c3e6cb;
        }
        .message.error {
          background-color: #f8d7da;
          color: #721c24;
          border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <ul class="navbar">
        <li><a href="home.jsp">Home</a></li>
        <li><a href="withdraw.jsp">Withdraw</a></li>
        <li><a href="deposit.jsp">Deposit</a></li>
        <li><a href="transaction.jsp">Transaction</a></li>
        <li><a href="profile.jsp">Profile</a></li>
        <li style="float:right"><a href="logout.jsp">Logout</a></li>
    </ul>
    <h2>Deposit</h2>

    <div class="deposit-form">
        <form method="post">
            <label for="amount">Amount:</label>
            <input type="number" id="amount" name="amount" required>
            <button type="submit">Deposit</button>
        </form>
    </div>

    <%
        // JDBC connection parameters
        String dbUrl = "jdbc:mysql://localhost:3306/akshar";
        String dbUser = "root";
        String dbPassword = "Root";

        Connection connection = null;
        PreparedStatement statement = null;

        try {
            // Establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // Retrieve customer ID from session
            String customerId = (String)session.getAttribute("coustomer_id");

            // Retrieve amount to deposit from the form
            double depositAmount = Double.parseDouble(request.getParameter("amount"));

            if (depositAmount > 0) {
                // Deposit amount is valid, proceed with deposit
                statement = connection.prepareStatement("UPDATE customer_balance SET balance = balance + ? WHERE coustomer_id = ?");
                statement.setDouble(1, depositAmount);
                statement.setString(2, customerId);
                statement.executeUpdate();

                // Insert deposit transaction into the transaction table
                statement = connection.prepareStatement("INSERT INTO transaction (coustomer_id, amount, transaction_type) VALUES (?, ?, ?)");
                statement.setString(1, customerId);
                statement.setDouble(2, depositAmount);
                statement.setString(3, "Deposit");
                statement.executeUpdate();

                // Display success message
                out.println("<div class=\"message success\">Deposit successful!</div>");
            } else {
                // Invalid deposit amount, display error message
                out.println("<div class=\"message error\">Invalid amount. Please enter a positive value.</div>");
            }

        } catch (Exception e) {
            // Display error message
            out.println("<div class=\"message error\">Error: " + e.getMessage() + "</div>");
        } finally {
            // Close resources in the finally block
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                out.println("<div class=\"message error\">Error closing resources: " + e.getMessage() + "</div>");
            }
        }
    %>
</body>
</html>
