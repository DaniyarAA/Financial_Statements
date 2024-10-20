<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0 0 0 560px;
            background-color: #f7f7f7;
        }
        .user-form-container {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 300px;
            text-align: center;
            position: relative;
        }
        .user-form-container h2 {
            font-size: 20px;
            color: #333;
            margin-bottom: 10px;
        }
        .user-form-container img {
            width: 80px;
            height: 80px;
            margin-bottom: 10px;
        }
        .user-form-container label {
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
            color: #666;
        }
        .user-form-container input[type="text"],
        .user-form-container input[type="date"],
        .user-form-container select,
        .user-form-container textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
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
        .delete-icon, .archive-icon {
            position: absolute;
            top: 10px;
            cursor: pointer;
        }
        .delete-icon {
            right: 10px;
        }
        .archive-icon {
            left: 10px;
        }
        .status {
            color: green;
            font-weight: bold;
        }
        .icon-button {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #ddd;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin: 0 auto;
        }
    </style>

    <div class="user-form-container">
        <form action="/admin/edit/${userDto.id}" method="post" enctype="multipart/form-data">
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                       value="${(_csrf.token)!'--no-token--'}"/>
            </#if>
            <span class="delete-icon">🗑️</span>

            <h2>Редактирование пользователя: ${userDto.name} ${userDto.surname}</h2>

<#--            <img src="${userDto.avatar?string('https://via.placeholder.com/80')}" alt="User Icon">TODO логика для фото юзера-->

            <label for="role">Роль:</label>
            <select id="role" name="roleId">
                <#list roles as role>
                    <option value="${role.id}" >${role.roleName}</option>
                </#list>
            </select>

            <label for="name">login:</label>
            <input type="text" id="login" name="login" value="${userDto.login}" placeholder="Введите логин">

            <label for="name">Имя:</label>
            <input type="text" id="name" name="name" value="${userDto.name}" placeholder="Введите имя">

            <label for="surname">Фамилия:</label>
            <input type="text" id="surname" name="surname" value="${userDto.surname}" placeholder="Введите фамилию">

<#--            <label for="contacts">Доступные компании:</label>-->
<#--            <input type="text" id="contacts" name="contacts" value="${userDto.copanies}" placeholder="Введите контакты">TODO логика для списка компаний у юзера-->

            <label for="birthdate">Дата рождения:</label>
            <input type="date" id="birthdate" name="birthday" value="${userDto.birthday}">

<#--            <label for="notes">Заметки:</label>-->
<#--            <textarea id="notes" name="notes" rows="3" placeholder="Введите заметки">${userDto.notes}</textarea>-->

            <div class="icon-button">📁</div>

            <label for="notes">Заметки:</label>
            <textarea id="notes" rows="3" placeholder="Не добавляй больше 20 компаний под управление"></textarea>
            <button type="submit">Сохранить</button>
        </form>
    </div>
</@layout.layout>