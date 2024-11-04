<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <div class="header mt-3">
        <h2>Пользователи</h2>
        <div class="view-icons">
        <span class="icon" onclick="switchToTileView()">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-grid-fill" viewBox="0 0 16 16">
                <path d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zm8 0A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm-8 8A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm8 0A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3z"/>
            </svg>
        </span>
            <span class="icon" onclick="switchToListView()">&#x2630;</span>
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


    <div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">

                <i class="bi bi-trash delete-icon fs-1"></i>

                <div class="modal-header">
                    <h5 class="modal-title" id="userModalLabel"></h5>
                </div>

                <div class="modal-body text-center">
                    <div>
                        <img src="/user.png" id="avatar" alt="avatar" class="profile-info-avatar-img">
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
