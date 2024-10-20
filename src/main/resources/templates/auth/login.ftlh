<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f7f7f7;
        }
        .login-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 300px;
        }
        .login-container h2 {
            margin-top: 0;
            font-size: 18px;
            color: #555;
        }
        .login-container img {
            width: 80px;
            height: 80px;
            margin-bottom: 10px;
        }
        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .login-container button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .login-container button:hover {
            background-color: #45a049;
        }
    </style>
    <div class="login-container">
        <h2>Добро Пожаловать, Олег</h2>
        <img src="/static/user.png" alt="User Icon">
        <form id="login-form" action="/auth/login" method="post">

            <!-- CSRF -->
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                       value="${(_csrf.token)!'csrf-token'}"/>
            </#if>
            <div data-mdb-input-init class="form-outline mb-4">
                <input type="text" id="form2Example1" class="form-control" name="username" placeholder="Login"/>
                <label class="form-label" for="form2Example1"></label>
            </div>
            <div data-mdb-input-init class="form-outline mb-4">
                <input type="password" id="form2Example2" class="form-control" name="password" placeholder="Password"/>
                <label class="form-label" for="form2Example2"></label>
            </div>
            <button type="submit">Войти</button>
        </form>
    </div>
</@layout.layout>
