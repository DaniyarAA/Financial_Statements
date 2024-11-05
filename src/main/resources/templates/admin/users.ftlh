<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <div class="header mt-3">
        <h2>Пользователи</h2>
        <div class="view-icons">
        <span class="icon" onclick="switchToTileView()">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-grid-fill"
                 viewBox="0 0 16 16">
                <path d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zm8 0A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm-8 8A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm8 0A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3z"/>
            </svg>
        </span>
            <span class="icon" onclick="switchToListView()">&#x2630;</span>
            <a class="icon" href="/admin/roles">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                     class="bi bi-person-fill-gear" viewBox="0 0 16 16">
                    <path d="M11 5a3 3 0 1 1-6 0 3 3 0 0 1 6 0m-9 8c0 1 1 1 1 1h5.256A4.5 4.5 0 0 1 8 12.5a4.5 4.5 0 0 1 1.544-3.393Q8.844 9.002 8 9c-5 0-6 3-6 4m9.886-3.54c.18-.613 1.048-.613 1.229 0l.043.148a.64.64 0 0 0 .921.382l.136-.074c.561-.306 1.175.308.87.869l-.075.136a.64.64 0 0 0 .382.92l.149.045c.612.18.612 1.048 0 1.229l-.15.043a.64.64 0 0 0-.38.921l.074.136c.305.561-.309 1.175-.87.87l-.136-.075a.64.64 0 0 0-.92.382l-.045.149c-.18.612-1.048.612-1.229 0l-.043-.15a.64.64 0 0 0-.921-.38l-.136.074c-.561.305-1.175-.309-.87-.87l.075-.136a.64.64 0 0 0-.382-.92l-.148-.045c-.613-.18-.613-1.048 0-1.229l.148-.043a.64.64 0 0 0 .382-.921l-.074-.136c-.306-.561.308-1.175.869-.87l.136.075a.64.64 0 0 0 .92-.382zM14 12.5a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0"/>
                </svg>
            </a>
            <span class="icon" onclick="window.location.href='/admin/register'">+</span>
        </div>
    </div>

    <div id="listView" class="view-container">
        <div class="user-list-container">
            <table class="user-table">
                <#list users.content as user>
                    <tr class="user-row">
                        <td class="user-info">
                            <span>#${user.id}. ${user.name} ${user.surname}</span>
                            <span>Reg: ${user.registerDate}</span>
                            <span><#if user.enabled==true>
                                Active
                                <#else>
                                    Disabled
                                </#if></span>
                            <span>${user.roleDto.roleName}</span>
                        </td>
                        <td class="user-action-buttons">
                            <button class="edit-button" data-bs-toggle="modal" data-bs-target="#userModal" data-user-id="${user.id}">✏️</button>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>

    <div id="tileView" class="view-container hidden">
        <div class="user-tile-container">
            <#list users.content as user>
                <div class="user-tile">
                    <div class="user-tile-info">
                        <span>#${user.id}.${user.name} ${user.surname}</span>
                        <span class="user-detail">Reg: ${user.registerDate}</span>
                        <#if user.enabled == true>
                            <span class="user-status user-detail">Active</span>
                        <#else>
                            <span class="user-status user-detail">Disabled</span>
                        </#if>
                        <span class="user-detail">Role: ${user.roleDto.roleName}</span>
                        <button class="edit-button" data-bs-toggle="modal" data-bs-target="#userModal" data-user-id="${user.id}">✏️</button>
                    </div>
                </div>
            </#list>
        </div>
    </div>

    <div class="d-flex justify-content-center mt-4">
        <nav aria-label="Page navigation example">
            <ul class="pagination">
                <li class="page-item <#if !users.hasPrevious()>disabled</#if>">
                    <a class="page-link" href="?page=${users.number - 1}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                <#assign startPage = users.number + 1 - 1>
                <#if startPage < 1>
                    <#assign startPage = 1>
                </#if>

                <#list startPage..(startPage + 2) as i>
                    <#if i <= users.totalPages>
                        <li class="page-item <#if (i - 1) == users.number>active</#if>">
                            <a class="page-link" href="?page=${i - 1}">${i}</a>
                        </li>
                    </#if>
                </#list>

                <li class="page-item <#if !users.hasNext()>disabled</#if>">
                    <a class="page-link" href="?page=${users.number + 1}" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </div>


    <div class="modal fade user-fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content user-modal-content">

                <i class="bi bi-trash delete-icon fs-1"></i>

                <div class="modal-header user-modal-header">
                    <h5 class="modal-title user-modal-title" id="userModalLabel"></h5>
                </div>

                <div class="modal-body text-center">
                    <div class="avatar-container">
                        <img src="/user.png" id="avatar" alt="avatar" class="profile-info-avatar-img">
                        <div id="change-avatar-icon" class="change-avatar-icon"  onclick="uploadAvatar()">
                            <i class="bi bi-camera fs-5"></i>
                        </div>
                        <input type="file" id="avatarInput" style="display: none;" accept="image/*">
                    </div>


                    <div class="user-info-row mt-3 mb-2">
                        <span class="user-label">Роль:</span>
                        <span class="user-value d-flex align-items-center" style="gap: 5px;">
                            <span id="roleDisplay"></span>
                            <select id="roleSelect" class="form-select" style="display: none; width: auto;">

                            </select>
                            <i class="bi bi-pencil" onclick="toggleRoleEdit()"></i>
                        </span>
                    </div>

                    <div class="user-info-row mb-2">
                        <span class="user-label">Статус:</span>
                        <span class="user-value" id="user-status"></span>
                    </div>


                    <div class="user-info-row mb-2">
                        <span class="user-label">Доступные компании:</span>
                        <span class="user-value d-flex align-items-center" style="gap: 5px; position: relative;">
                        <span id="initialCompanies"></span>
                        <div id="companyDropdown" style="display: none;">
                            <div id="companyCheckboxes" class="dropdown-menu p-3">

                            </div>
                        </div>
                        <i class="bi bi-pencil" onclick="toggleCompanyEdit()" id="edit-company-icon" style="position: absolute; right: -25px; cursor: pointer;"></i>
                    </span>
                    </div>


                    <div class="user-info-row">
                        <span class="user-label">День Рождения:</span>
                        <span class="user-value" id="user-birthday"></span>
                    </div>

                    <div class="user-info-row mb-2">
                        <span class="user-label">Архив:</span>
                        <span class="user-value"><i class="bi bi-archive fs-1"></i></span>
                    </div>

                    <div class="mt-3">
                        <p class="user-label text-start ms-4">Заметки:</p>
                        <textarea id="notesInput" name="notes" class="form-control notes-form p-3 pb-5 mt-2"></textarea>
                    </div>

                    <button class="btn btn-light edit-user-btn mt-1 mb-3">
                        <i class="bi bi-check2 fs-1"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div id="notification" class="notification"></div>


    <script src="/js/script.js"></script>

</@layout.layout>
