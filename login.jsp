<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
int a = (int)(Math.random() * 100);
int b = (int)(Math.random() * 100);

session.setAttribute("captchaAnswer", a + b);

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Login - Online Exam Portal</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="icon" href="online-test.png" type="image/png">
</head>
<body>

    <%-- <% Boolean success = (Boolean) request.getAttribute("success"); %>
    <div id="success-popup">
    <span style="margin-right:8px;">✔</span> Login Successful!
    </div> --%>


    <div class="page-wrapper">
    <div class="login-container">
        <h2>Login</h2>
        <form action="login" method="post">
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <br><label>Solve CAPTCHA:</label>
            
            <div id="captchaDisplay" style="background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);height:60px;align-items:center;padding-top:10px;margin-right:400px;margin-left:400px;"><p><strong><%= a %> + <%= b %> = ?</strong></p></div>

                        
            <%-- <button id="refresh-btn" onclick="refreshCaptcha()" style="background:url('images/refresh.png'); background-repeat: no-repeat;
    background-size: 50px 50px;"></button> --%>

                <input type="number" name="captcha" required>
                
            <input type="submit" value="Login">
        </form>
        <p class="error-message">
            <%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %>
        </p>
        <p>New user? <a href="register.jsp">Register here</a></p>
        <br>
        <br>
        <a href = "index.jsp">Home</a>
    </div>
    </div>

    <script>


    function refreshCaptcha()
    {
        const img = document.getElementById('')
    }
        
    document.addEventListener("contextmenu", function(e){
    e.preventDefault();
    });

    /* Dev tools / inspect */
    if (
        e.key === "F12" ||
        (e.ctrlKey && e.shiftKey && ["i","c","j"].includes(e.key.toLowerCase())) ||
        (e.ctrlKey && ["u","s"].includes(e.key.toLowerCase()))
    ) {
        e.preventDefault();
    }

</script>
</body>
</html>
