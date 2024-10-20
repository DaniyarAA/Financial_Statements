<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .header h2 {
            margin: 0;
            font-size: 18px;
        }

        .view-icons {
            display: flex;
            gap: 10px;
        }

        .icon {
            font-size: 20px;
            cursor: pointer;
            padding: 5px;
        }

        .icon:hover {
            background-color: #e0e0e0;
            border-radius: 5px;
        }

        .user-list-container {
            margin: 20px;
        }

        .user-list-container h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .user-table {
            width: 100%;
            margin: auto;
            border-collapse: collapse;
        }

        .user-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            background-color: #fff;
            border: 1px solid #ccc;
            margin-bottom: 10px;
            border-radius: 10px;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-info span {
            font-size: 14px;
        }

        .user-action-buttons {
            display: flex;
            align-items: center;
        }

        .edit-button, .add-user-button {
            background-color: #4CAF50;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 10px;
        }

        .edit-button {
            background-color: #4CAF50;
        }

        .add-user-button {
            background-color: #008CBA;
        }

        .edit-button:hover, .add-user-button:hover {
            background-color: #45a049;
        }

        .disabled {
            color: #888;
        }
    </style>

    <div class="header">
        <h2>Пользователи</h2>
        <div class="view-icons">

            <span class="icon" onclick="switchToTileView()"> <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-grid-fill" viewBox="0 0 16 16">
                <path d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zm8 0A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm-8 8A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm8 0A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3z"/>
            </svg></span>
            <span class="icon" onclick="switchToListView()">&#x2630;</span>
            <span class="icon" onclick="window.location.href='/admin/register'">+</span>
        </div>
    </div>

    <div class="user-list-container" id="userContainer">
        <table class="user-table">
            <#list users as user>
                <tr class="user-row">
                    <td class="user-info">
                        <span>#${user.id}.${user.name} ${user.surname}</span>
                        <span>Reg: ${user.registrationDate}</span>
<#--                        <span class="${user.isActive ? 'active' : 'disabled'}">${user.isActive ? 'Active' : 'Disabled'} ${user.role.name}</span>-->
                    </td>
                    <td class="user-action-buttons">
                        <button class="edit-button" onclick="window.location.href='/admin/edit/${user.id}'">✏️</button>
                    </td>
                </tr>
            </#list>
        </table>
    </div>

    <script>
        function switchToTileView() {
            document.getElementById('userContainer').classList.add('tile-view');
            document.getElementById('userContainer').classList.remove('list-view');
        }

        function switchToListView() {
            document.getElementById('userContainer').classList.add('list-view');
            document.getElementById('userContainer').classList.remove('tile-view');
        }
    </script>
</@layout.layout>
