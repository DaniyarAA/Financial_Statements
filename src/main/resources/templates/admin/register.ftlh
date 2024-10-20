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
        .user-form-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
            position: relative;
        }
        .user-form-container h2 {
            font-size: 22px;
            color: #333;
            margin-bottom: 20px;
        }
        .user-form-container label {
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
            color: #666;
        }
        .user-form-container input[type="text"],
        .user-form-container input[type="date"],
        .user-form-container input[type="password"],
        .user-form-container select,
        .user-form-container textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .user-form-container button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .user-form-container button:hover {
            background-color: #45a049;
        }
    </style>

    <div class="user-form-container">
        <h2>Регистрация нового пользователя</h2>
        <form action="/admin/register" method="post" enctype="multipart/form-data">
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                       value="${(_csrf.token)!'--no-token--'}"/>
            </#if>

            <label for="name">Имя:</label>
            <input type="text" id="name" name="name" placeholder="Введите имя" required>

            <label for="surname">Фамилия:</label>
            <input type="text" id="surname" name="surname" placeholder="Введите фамилию" required>

            <label for="login">Логин:</label>
            <input type="text" id="login" name="login" placeholder="Введите логин" required>

            <label for="password">Пароль:</label>
            <input type="password" id="password" name="password" placeholder="Введите пароль" required>

            <label for="roleId">Роль:</label>
            <select id="roleId" name="roleId" required>
                <#list roles as role>
                    <option value="${role.id}">${role.roleName}</option>
                </#list>
            </select>

            <label for="birthday">Дата рождения:</label>
            <input type="date" id="birthday" name="birthday" required>

<#--            <label for="avatar">Аватар:</label>-->
<#--            <input type="file" id="avatar" name="avatar" accept="image/*">TODO логика для аватарки-->

            <label for="isActive">Активен:</label>
            <input type="checkbox" id="isActive" name="isActive" checked>

            <button type="submit">Создать пользователя</button>
        </form>
    </div>
</@layout.layout>