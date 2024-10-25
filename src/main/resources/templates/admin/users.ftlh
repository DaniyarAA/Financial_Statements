<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

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
                        <span>Reg: ${user.registerDate}</span>
                        <#if user.enabled == true>
                            <span>Active</span>
                        <#else >
                            <span>Disabled</span>
                        </#if>
                        <span>Role: ${user.roleDto.roleName}</span>
                    </td>
                    <td class="user-action-buttons">
                        <button class="edit-button" onclick="window.location.href='/admin/user/edit/${user.id}'">✏️</button>
                    </td>
                </tr>
            </#list>
        </table>
    </div>


</@layout.layout>
