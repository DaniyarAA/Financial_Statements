<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="users-layout">
        <div class="users-header mt-3">
            <p class="users-list-title">Пользователи</p>
            <div class="view-icons">
                <span class="icon" onclick="switchToTileView()"><i class="bi bi-grid"></i></span>
                <span class="icon" onclick="switchToListView()"><i class="bi bi-list-ul"></i></span>

                <#list currentUser.roleDto.authorities as auth>
                    <#if auth.authority=="VIEW_ROLES">
                        <span class="icon" onclick="window.location.href='/admin/roles'">
                                <i class="bi bi-person-fill-gear"></i>
                        </span>
                    </#if>
                    <#if auth.authority=="CREATE_USER">
                        <span class="icon" onclick="window.location.href='/admin/register'">
                                <i class="bi bi-plus-circle"></i>
                            </span>
                    </#if>
                </#list>
            </div>
        </div>

        <div id="listView" class="view-container listView hidden">
            <div class="user-list-container">
                <table class="user-table">
                    <#list users.content as user>
                        <tr class="user-row">
                            <td class="user-info">
                                    <span id="list-${user.id}-name-surname" class="user-name-surname">#${user.displayIndex}.${user.name} ${user.surname}</span>
                                    <span class="user-table-detail">Reg.: ${user.registerDate}</span>
                                    <span class="user-table-detail" id="list-${user.id}-list-status"><#if user.enabled==true>
                                Active
                                <#else>
                                            Disabled
                                        </#if></span>
                                    <#if user.roleDto??>

                                    </#if>
                                    <span id="list-${user.id}-role" class="user-table-detail">
                                        <#if user.roleDto??>
                                            ${user.roleDto.roleName}
                                            <#else >
                                            Удален
                                        </#if>
                                    </span>
                                </td>

                            <td class="user-action-buttons">
                                <#list currentUser.roleDto.authorities as auth>
                                    <#if auth.authority=="EDIT_USER">
                                        <button class="edit-button" data-bs-toggle="modal"
                                                data-bs-target="#changeLoginPasswordModal" data-user-id="${user.id}"><i
                                                    class="bi bi-key"></i></button>                                    </#if>
                                </#list>

                                <button class="edit-button" data-bs-toggle="modal" data-bs-target="#userModal"
                                        data-user-id="${user.id}"><i class="bi bi-pencil"></i></button>
                            </td>

                            <input type="hidden" id="currentUserId" value="${currentUser.id}">
                        </tr>
                    </#list>
                </table>
            </div>
        </div>

            <div id="tileView" class="view-container tileView hidden">
                <div class="user-tile-container">
                    <#list users.content as user>
                        <div class="user-tile">
                            <div class="user-tile-info">
                                <span id="tile-${user.id}-name-surname" class="user-name-surname">#${user.displayIndex}.${user.name} ${user.surname}</span>
                                <span class="user-detail">Reg.: ${user.registerDate}</span>

                                <span class="user-table-detail" id="${user.id}-tile-status">
                                    <#if user.enabled==true>
                                        Active
                                    <#else>
                                        Disabled
                                    </#if>
                                </span>

                                <span class="user-detail" id="tile-${user.id}-role">
                                   <#if user.roleDto??>
                                       ${user.roleDto.roleName}
                                   <#else >
                                       Удален
                                   </#if>
                                </span>
                                    <div class="buttons-container">
                                        <button class="edit-button" data-bs-toggle="modal" data-bs-target="#changeLoginPasswordModal" data-user-id="${user.id}"><i class="bi bi-key"></i>
                                        </button>
                                        <button class="edit-button" data-bs-toggle="modal" data-bs-target="#userModal" data-user-id="${user.id}"><i class="bi bi-pencil"></i></button>
                                    </div>
                                <input type="hidden" id="currentUserId" value="${currentUser.id}">
                            </div>
                        </div>
                    </#list>
                </div>
            </div>


        <div class="d-flex justify-content-center mt-5">
            <nav aria-label="Page navigation example">
                <ul class="pagination">
                    <li class="page-item <#if !users.hasPrevious()>disabled</#if>">
                        <a class="page-link" href="?page=${users.number - 1}" aria-label="Previous">
                            <span class="aria-hidden-1" aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <#assign startPage = users.number + 1 - 1>
                    <#if startPage < 1>
                        <#assign startPage = 1>
                    </#if>

                    <#list startPage..(startPage + 2) as i>
                        <#if i <= users.totalPages>
                            <li class="page-item <#if (i - 1) == users.number>active</#if>">
                                <a class="page-link pagination" href="?page=${i - 1}">${i}</a>
                            </li>
                        </#if>
                    </#list>

                    <li class="page-item <#if !users.hasNext()>disabled</#if>">
                        <a class="page-link" href="?page=${users.number + 1}" aria-label="Next">
                            <span class="aria-hidden-1" aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>

    <div class="modal fade user-fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true" style="display: none">
        <#assign hasEditUserAuthority = false />
        <#list currentUser.roleDto.authorities as auth>
            <#if auth.authority == "EDIT_USER">
                <#assign hasEditUserAuthority = true />
                <#break>
            </#if>
        </#list>
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content user-modal-content">

                <button type="button" class="btn-close user-modal-close-button" data-bs-dismiss="modal" aria-label="Close"></button>

                <#list currentUser.roleDto.authorities as auth>
                    <#if auth.authority=="DELETE_USER">
                        <i class="bi bi-trash delete-icon fs-1" id="delete-user-icon" onclick="deleteUser()"></i>
                    </#if>
                </#list>

                <div class="modal-header user-modal-header">
                    <h5 class="modal-title user-modal-title ms-3" id="userModalLabel"></h5>
                    <h5 class="modal-title user-modal-title ms-2" id="surnameModalLabel"></h5>
                    <input type="text" class="form-control fs-5" id="userNameInput" style="display: none; padding: 0; width: 28%">
                    <input type="text" class="form-control fs-5" id="surnameNameInput" style="display: none; padding: 0; width: 32%">

                    <#if hasEditUserAuthority>
                        <i class="bi bi-pencil ms-2" id="edit-name-icon" onclick="toggleNameEdit()"></i>
                    </#if>
                </div>

                <div class="modal-body text-center">
                    <div class="avatar-container">
                        <img src="/api/files/download/user.png" id="avatar" alt="avatar"
                             class="profile-info-avatar-img">
                        <#if hasEditUserAuthority>
                            <div id="change-avatar-icon" class="change-avatar-icon" onclick="uploadAvatar()">
                                <i class="bi bi-camera fs-5"></i>
                            </div>
                            <input type="file" id="avatarInput" style="display: none;" accept="image/*">
                        </#if>

                    </div>


                    <div class="user-info-row mt-3 mb-2">
                        <span class="user-label">Роль:</span>
                        <span class="user-value d-flex align-items-center" style="gap: 5px;">
                            <span id="roleDisplay"></span>
                            <select id="roleSelect" class="form-select" style="display: none; width: 85%;">

                            </select>

                            <#if hasEditUserAuthority>
                                <i class="bi bi-pencil" id="edit-role-icon" onclick="toggleRoleEdit()"></i>
                            </#if>
                        </span>
                    </div>

                    <div class="user-info-row mb-2">
                        <span class="user-label">Статус:</span>
                        <span class="user-value" id="user-status"></span>
                    </div>

                    <div class="user-info-row mb-2">
                        <span class="user-label">Почта:</span>
                        <span class="user-value" id="user-email" style="overflow: hidden; text-overflow: ellipsis;"></span>
                        <input type="text" class="form-control fs-5" id="emailInput" style="display: none; padding: 0;">
                        <#if hasEditUserAuthority>
                            <i class="bi bi-pencil ms-2" id="edit-email-icon" onclick="toggleEmailEdit()"></i>
                        </#if>
                    </div>


                    <div class="user-info-row mb-2">
                        <span class="user-label">Доступные компании:</span>
                        <span class="user-value d-flex align-items-center" style="gap: 5px; position: relative;">
                        <span id="initialCompanies"></span>
                        <div id="companyDropdown" style="display: none;">
                            <input type="text" id="companySearch" placeholder="Поиск компаний..."
                                   class="form-control mb-2">
                            <div id="companyCheckboxes" class="dropdown-menu p-3">

                            </div>
                        </div>

                            <#if hasEditUserAuthority>
                                <i class="bi bi-pencil" onclick="toggleCompanyEdit()" id="edit-company-icon"></i>
                            </#if>

                        </span>
                    </div>


                    <div class="user-info-row">
                        <span class="user-label">День Рождения:</span>
                        <span class="user-value" id="user-birthday"></span>
                        <input type="date" id="birthday-input" class="user-value" style="display: none; width: 35%; border: none">

                        <#if hasEditUserAuthority>
                            <i class="bi bi-pencil ms-2" id="edit-birthday-icon" onclick="toggleBirthdayEdit()"></i>
                        </#if>

                    </div>
                    <span id="birthdayError" class="text-danger"></span>

                    <div class="user-info-row mb-2">
                        <span class="user-label">Архив:</span>
                        <span class="user-value"><i class="bi bi-archive fs-1"></i></span>
                    </div>

                    <div class="mt-3">
                        <p class="user-label text-start ms-4">Заметки:</p>
                        <textarea id="notesInput" name="notes" class="form-control notes-form p-3 pb-5 mt-2"
                                  <#if !hasEditUserAuthority>disabled</#if>
                        ></textarea>
                    </div>

                    <button class="btn btn-light edit-user-btn mt-1 mb-3" id="edit-user-info-button"
                            <#if !hasEditUserAuthority>disabled</#if>
                    >
                        <i class="bi bi-check2 fs-1"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="changeLoginPasswordModal" tabindex="-1" aria-labelledby="changeLoginPasswordModalLabel"
         aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content shadow">
                <div class="modal-header bg-color-for-change-login-password text-black">
                    <h5 class="modal-title" id="changeLoginPasswordModalLabel">Изменение логина и пароля</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="changeLoginPasswordForm">
                        <div class="mb-3">
                            <label for="newLogin" class="form-label">Новый логин</label>
                            <input type="text" id="newLogin" class="form-control form-control-lg"
                                   placeholder="Введите новый логин">
                            <div id="loginErrorMessage" class="text-danger small mt-1"></div>
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">Новый пароль</label>
                            <div class="input-group">
                                <input type="password" id="newPassword" class="form-control form-control-lg"
                                       placeholder="Введите новый пароль">
                                <button type="button" class="btn btn-outline-secondary" id="toggleNewPassword">
                                    <i class="bi bi-eye-slash" id="newPasswordEyeIcon"></i>
                                </button>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Подтвердите пароль</label>
                            <div class="input-group">
                                <input type="password" id="confirmPassword" class="form-control form-control-lg"
                                       placeholder="Повторите новый пароль">
                                <button type="button" class="btn btn-outline-secondary" id="toggleConfirmPassword">
                                    <i class="bi bi-eye-slash" id="confirmPasswordEyeIcon"></i>
                                </button>
                            </div>
                            <div id="passwordErrorMessage" class="text-danger small mt-1"></div>
                        </div>
                    </form>
                </div>
                <div class="d-flex justify-content-center align-items-center modal-footer change-login-password-footer">
                    <button type="button" class="btn btn-primary change-login-password-btn"
                            onclick="saveLoginAndPassword()">
                        <i class="bi bi-check2 check-icon"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmModalLabel">Подтвердите действие:</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="confirmMessage">
                    Вы уверены, что хотите удалить этого пользователя?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Нет</button>
                    <button type="button" class="btn btn-danger" id="confirmYes">Да</button>
                </div>
            </div>
        </div>
    </div>

    <div id="notification" class="notification"></div>


    <script src="/js/users.js"></script>

</@layout.layout>
