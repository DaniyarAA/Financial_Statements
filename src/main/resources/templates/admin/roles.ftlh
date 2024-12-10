<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="container role-list-container">
        <h2 class="text-center">Список ролей</h2>
        <div class="role-list">
            <#list roles as role>
                <div class="role-item">
                    <span>${role.roleName}</span>
                    <div class="button-group">
                        <#list currentUser.roleDto.authorities as auth>
                            <#if auth.authority=="DELETE_ROLE">
                                <#if !role.userIds ? has_content && role.roleName != "Бухгалтер">
                                    <button class="btn btn-danger" onclick="deleteRole(${role.id}, '${role.roleName}')">
                                        <span id="roleAccountError" class="text-danger"></span>
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                             fill="currentColor"
                                             class="bi bi-trash3-fill" viewBox="0 0 16 16">
                                            <path d="M11 1.5v1h3.5a.5.5 0 0 1 0 1h-.538l-.853 10.66A2 2 0 0 1 11.115 16h-6.23a2 2 0 0 1-1.994-1.84L2.038 3.5H1.5a.5.5 0 0 1 0-1H5v-1A1.5 1.5 0 0 1 6.5 0h3A1.5 1.5 0 0 1 11 1.5m-5 0v1h4v-1a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5M4.5 5.029l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5a.5.5 0 1 0-.998.06m6.53-.528a.5.5 0 0 0-.528.47l-.5 8.5a.5.5 0 0 0 .998.058l.5-8.5a.5.5 0 0 0-.47-.528M8 4.5a.5.5 0 0 0-.5.5v8.5a.5.5 0 0 0 1 0V5a.5.5 0 0 0-.5-.5"/>
                                        </svg>
                                    </button>
                                </#if>
                            </#if>
                            <#if auth.authority=="EDIT_ROLE">
                                <button class="btn btn-black"
                                        onclick="openEditRoleModal(${role.id}, '${role.roleName}')">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                         class="bi bi-pencil" viewBox="0 0 16 16">
                                        <path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325"/>
                                    </svg>
                                </button>
                            </#if>
                        </#list>
                    </div>
                </div>
            </#list>
        </div>
        <#list currentUser.roleDto.authorities as auth>
            <#if auth.authority=="CREATE_ROLE">
                <button class="btn btn-create-role mt-3" onclick="openCreateRoleModal()">Создать новую роль</button>
            </#if>
        </#list>
    </div>

    <div id="editRoleModal" class="modal role-modal" tabindex="-1">
        <div class="modal-dialog role-modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header role-modal-header">
                    <h5 class="modal-title role-modal-title">Редактирование роли</h5>
                    <button type="button" class="btn-close btn-close-role" id="closeModalButtonCreateRole" aria-label="Close"
                            onclick="closeModal('editRoleModal')"></button>
                </div>
                <div class="modal-body">
                    <form id="editRoleForm">
                        <input type="hidden" id="editRoleId">
                        <input type="hidden" name="csrf" value="${_csrf.token}" id="csrfToken">

                        <div class="form-group">
                            <label for="editRoleName">Название роли</label>
                            <input type="text" id="editRoleName" name="roleName" class="form-control" required>
                            <span id="roleNameError" class="text-danger"></span>
                        </div>

                        <h5>Права доступа</h5>
                        <div class="authorities-for-role-scroll">
                        <div id="editAuthoritiesContainer">
                        </div>
                        </div>
                        <span id="authorityError" class="text-danger"></span>
                    </form>
                </div>
                <div class="modal-footer role-modal-footer d-flex justify-content-center">
                    <button type="button" class="btn btn-success role-btn create-role-button role-btn-secondary" onclick="saveRole()"><i class="bi bi-check2 check-icon-role"></i></button>
                </div>
            </div>
        </div>
    </div>

    <div id="createRoleModal" class="modal role-modal" tabindex="-1">
        <div class="modal-dialog role-modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header role-modal-header">
                    <h5 class="modal-title role-modal-title">Создание новой роли</h5>
                    <button type="button" class="btn-close btn-close-role" id="closeModalButtonCreateRole" aria-label="Close"
                            onclick="closeModal('createRoleModal')"></button>
                </div>
                <div class="modal-body">
                    <form id="createRoleForm">
                        <input type="hidden" name="csrf" value="${_csrf.token}" id="csrfToken">
                        <div class="form-group">
                            <label for="createRoleName">Название роли</label>
                            <input type="text" id="createRoleName" name="roleName" class="form-control" required>
                            <span id="roleNameError" class="text-danger"></span>
                        </div>
                        <h5>Права доступа</h5>
                        <div class="authorities-for-role-scroll">
                        <#list authorities as authority>
                            <div class="form-check">
                                <input type="checkbox" id="create_auth_${authority.id}" name="authorityIds"
                                       value="${authority.id}" class="form-check-input">
                                <label for="create_auth_${authority.id}"
                                       class="form-check-label">${authority.authorityName}</label>
                            </div>
                        </#list>
                        </div>
                        <span id="authorityError" class="text-danger"></span>
                    </form>
                </div>
                <div class="modal-footer role-modal-footer d-flex justify-content-center">
                    <button type="button" class="btn btn-success role-btn create-role-button role-btn-secondary" onclick="createRole()"><i class="bi bi-check2 check-icon-role"></i></button>
                </div>
            </div>
        </div>
    </div>

    <script src="/js/roles.js"></script>
</@layout.layout>