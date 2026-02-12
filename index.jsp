<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Online Exam Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
     <link rel="stylesheet" href="css/style.css">
     <link rel="icon" href="online-test.png" type="image/png">

</head>
<body>
<style>
   html,body
   {
        overflow:hidden;
   }

#chatbot {
    position: fixed;
    bottom: 150px;
    right: 20px;
    width: 400px;
    height:400px;
    background: #ffffff;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(187, 43, 43, 0.2);
    display: none;
    flex-direction: column;
    font-family: Poppins, sans-serif;
    z-index: 9999;
}

#chatbot-header {
    background: #333150;
    color: white;
    padding: 12px;
    font-weight: 600;
    border-radius: 12px 12px 0 0;
    text-align: center;
    cursor:move;
}

#chatbot-messages {
    flex:1;
    overflow-y: auto;
    padding: 10px;
    font-size: 20px;
}

.bot, .user {
    margin: 6px 0;
    padding: 8px 10px;
    border-radius: 8px;
    max-width: 90%;
}

.bot {
    background: #f1f5f9;
    align-self: flex-start;
}

.user {
    background: #36345e;
    color: white;
    align-self: flex-end;
    margin-left: 190px;
}

#chatbot-input {
    display: flex;
    border-top: 1px solid #ddd;
}

#chatbot-input input {
    flex: 1;
    border: none;
    padding: 5px;
    outline: none;
}

#chatbot-input button {
    background: #7150a7;
    color: white;
    border: none;
    padding: 10px 2px;
    cursor: pointer;
}

#chatbot-toggle {
    position: fixed;
    bottom: 120px;
    right: 20px;
    background: url('images/chatbot.png');
    background-repeat: no-repeat;
    background-size: 120px 110px; 
    
    color: white;
    border: none;
    border-radius: 50%;
    width: 120px;
    height: 110px;
    font-size: 30px;
    cursor: pointer;
    z-index: 9999;
}

</style>

   <video id="bg-video" autoplay muted loop>
        <source src="demo.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>

 <div class = "page-wrapper">
    <div class="container">
        <h1>Welcome to Online Examination Portal</h1>
        <p> Our Portal has the facility to attend Computer-based examinations in online mode, <br>also we added security features in our portal to attempt exam safely and download certificate instantly after the completion. <br>Also shows the analysis of questions attempted.</p>
        <a href="login.jsp">Login</a> 
        <a href="register.jsp">Register</a>
    </div>
    </div>

    <!-- CHATBOT -->
<div id="chatbot">
    <div id="chatbot-header">🤖 Exam Assistant</div>
        <%-- <span onclick="toggleChatbot()" style="float:right; cursor:pointer;">✖</span> --%>


    <div id="chatbot-messages">
        <div class="bot">Hello 👋<br>How can I help you?</div>
    </div>

    <div id="chatbot-input">
        <input type="text" id="userInput" placeholder="Type your question..." />
        <button onclick="sendMessage()">Send</button>
    </div>
</div>

<button id="chatbot-toggle" onclick="toggleChatbot()"></button>


<footer class="bottom-navbar">
    <div class="footer-left">
        <h3>Online Examination Portal</h3>
        <p>Secure • Reliable • Fast Online Assessments</p>
    </div>

    <div class="footer-center">
        <p><strong>Developed By:</strong> Jayesh Attarde</p>
        <p><strong>Email:</strong> jayeshattarde486@gmail.com</p>
        <p><strong>Contact:</strong> +91 7620596241</p>
    </div>

    <div class="footer-right">
        <p>© 2025 Online Exam Portal</p>
        <p>All Rights Reserved</p>
    </div>
</footer>

<script>

function toggleChatbot() {
    const bot = document.getElementById("chatbot");
    const button = document.getElementById("chatbot-toggle");

    if (bot.style.display === "flex") {
        bot.style.display = "none";
        button.style.display = "block";
    } else {
        bot.style.display = "flex";
        button.style.display = "none";
    }
}

function sendMessage() {
    const input = document.getElementById("userInput");
    const message = input.value.trim();
    if (message === "") return;

    addMessage(message, "user");
    input.value = "";

    showTyping();

    setTimeout(() => {
        removeTyping();
        botReply(message.toLowerCase());
    }, 800);
}

function addMessage(text, type) {
    const msgBox = document.getElementById("chatbot-messages");
    const div = document.createElement("div");
    div.className = type;
    div.innerHTML = text;
    msgBox.appendChild(div);
    msgBox.scrollTop = msgBox.scrollHeight;
}

function showTyping() {
    const msgBox = document.getElementById("chatbot-messages");
    const typing = document.createElement("div");
    typing.className = "bot";
    typing.id = "typing";
    typing.innerHTML = "Typing...";
    msgBox.appendChild(typing);
    msgBox.scrollTop = msgBox.scrollHeight;
}

function removeTyping() {
    const typing = document.getElementById("typing");
    if (typing) typing.remove();
}

function botReply(msg) {
    let reply = "";

    // LOGIN
    if (msg.includes("login") || msg.includes("sign in")) {
        reply = `
        🔐 <b>Login Assistance</b><br><br>
        To access your dashboard:<br>
        1️⃣ Click the <b>Login</b> button.<br>
        2️⃣ Enter your registered Email ID.<br>
        3️⃣ Provide your secure password.<br>
        4️⃣ Click <b>Submit</b>.<br><br>
        If you're facing login issues, ensure:<br>
        ✔ Correct credentials<br>
        ✔ Stable internet connection<br>
        ✔ Cookies enabled in browser
        `;
    }

    // REGISTER
    else if (msg.includes("register") || msg.includes("signup") || msg.includes("create account")) {
        reply = `
        📝 <b>Account Registration Guide</b><br><br>
        To create a new account:<br>
        • Click <b>Register</b><br>
        • Fill in accurate personal details<br>
        • Choose a strong password<br>
        • Submit the form<br><br>
        Once registered, you can immediately log in and access exams.
        `;
    }

    // EXAM
    else if (msg.includes("exam") || msg.includes("test") || msg.includes("assessment")) {
        reply = `
        🧠 <b>Online Examination Process</b><br><br>
        ✔ Login to your account<br>
        ✔ Select the assigned exam<br>
        ✔ Read instructions carefully<br>
        ✔ Start the timer-based assessment<br><br>
        <b>Security Measures:</b><br>
        • Full-screen enforcement<br>
        • Tab-switch detection<br>
        • Auto-submit on timeout<br>
        • Activity monitoring<br><br>
        `;
    }

    // CERTIFICATE
    else if (msg.includes("certificate") || msg.includes("result")) {
        reply = `
        🎓 <b>Result & Certificate Process</b><br><br>
        After exam completion:<br>
        • View your detailed performance analysis<br>
        • Check score & grading<br>
        • Click <b>Download Certificate</b><br><br>
        Certificates are auto-generated in secure PDF format.
        `;
    }

    // SECURITY
    else if (msg.includes("security") || msg.includes("safe") || msg.includes("cheat")) {
        reply = `
        🛡 <b>Security Architecture Overview</b><br><br>
        Our portal implements:<br>
        ✔ Session validation system<br>
        ✔ Browser activity tracking<br>
        ✔ Tab switch detection<br>
        ✔ Full-screen lock mechanism<br>
        ✔ Automatic logout on suspicious behavior<br><br>
        These ensure fair and transparent examination conduct.
        `;
    }

    // SUPPORT
    else if (msg.includes("contact") || msg.includes("support") || msg.includes("help")) {
        reply = `
        📞 <b>Technical Support</b><br><br>
        For assistance, contact:<br>
        📧 Email: jayeshattarde486@gmail.com<br>
        📱 Phone: +91 7620596241<br><br>
        Please include:<br>
        • Your registered email<br>
        • Exam name<br>
        • Screenshot (if technical issue)
        `;
    }

    // GREETING
    else if (msg.includes("hi") || msg.includes("hello") || msg.includes("hey")) {
        reply = `
        👋 Hello! I'm your <b>Online Exam Assistant</b>.<br><br>
        I can help you with:<br>
        • Login & Registration<br>
        • Exam Instructions<br>
        • Security Policies<br>
        • Certificates & Results<br>
        • Technical Support<br><br>
        How may I assist you today?
        `;
    }

    // DEFAULT SMART RESPONSE
    else {
        reply = `
        🤖 <b>I'm here to assist you.</b><br><br>
        You may ask about:<br>
        • How to login<br>
        • How to register<br>
        • Exam guidelines<br>
        • Certificate download<br>
        • Security features<br>
        • Technical support<br><br>
        Please provide a little more detail so I can guide you accurately.
        `;
    }

    addMessage(reply, "bot");
}

// ===== DRAGGABLE CHATBOT =====
dragElement(document.getElementById("chatbot"));

function dragElement(elmnt) {
    const header = document.getElementById("chatbot-header");

    let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

    if (header) {
        header.onmousedown = dragMouseDown;
    }

    function dragMouseDown(e) {
        e.preventDefault();

        pos3 = e.clientX;
        pos4 = e.clientY;

        document.onmouseup = closeDragElement;
        document.onmousemove = elementDrag;
    }

    function elementDrag(e) {
        e.preventDefault();

        pos1 = pos3 - e.clientX;
        pos2 = pos4 - e.clientY;
        pos3 = e.clientX;
        pos4 = e.clientY;

        elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
        elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";

        // Remove bottom/right positioning after drag
        elmnt.style.bottom = "auto";
        elmnt.style.right = "auto";
    }

    function closeDragElement() {
        document.onmouseup = null;
        document.onmousemove = null;
    }
}

// ===== CLOSE CHATBOT WHEN CLICKING OUTSIDE =====
document.addEventListener("click", function (event) {

    const chatbot = document.getElementById("chatbot");
    const toggleBtn = document.getElementById("chatbot-toggle");

    const isClickInsideChatbot = chatbot.contains(event.target);
    const isClickOnButton = toggleBtn.contains(event.target);

    if (!isClickInsideChatbot && !isClickOnButton) {
        if (chatbot.style.display === "flex") {
            chatbot.style.display = "none";
            toggleBtn.style.display = "block";
        }
    }
});

</script>


</body>
</html>
