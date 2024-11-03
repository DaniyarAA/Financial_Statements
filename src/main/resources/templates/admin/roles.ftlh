<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="role-list-container">
        <h2 class="text-center">Список ролей</h2>
        <#list roles as role>
            <div class="role-item">
                <span>${role.roleName}</span>
                <button class="btn btn-primary" onclick="openEditRoleModal(${role.id}, '${role.roleName}')">Редактировать</button>
                <#if !role.userIds ? has_content>
                    <button class="btn btn-danger" onclick="deleteRole(${role.id})">Удалить</button>
                </#if>
            </div>
        </#list>
        <button class="btn btn-success btn-create-role" onclick="openCreateRoleModal()">Создать новую роль</button>
    </div>

    <div id="editRoleModal" class="modal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Редактирование роли</h5>
                    <button type="button" class="close" onclick="closeModal('editRoleModal')">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="editRoleForm">
                        <input type="hidden" id="editRoleId">
                        <div class="form-group">
                            <label for="editRoleName">Название роли</label>
                            <input type="text" id="editRoleName" name="roleName" class="form-control" required>
                        </div>
                        <h5>Права доступа</h5>
                        <div id="editAuthoritiesContainer"></div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editRoleModal')">Закрыть</button>
                    <button type="button" class="btn btn-primary" onclick="saveRole()">Сохранить</button>
                </div>
            </div>
        </div>
    </div>

    <div id="createRoleModal" class="modal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Создание новой роли</h5>
                    <button type="button" class="close" onclick="closeModal('createRoleModal')">&times;</button>
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
                        <#list authorities as authority>
                            <div class="form-check">
                                <input type="checkbox" id="create_auth_${authority.id}" name="authorityIds" value="${authority.id}" class="form-check-input">
                                <label for="create_auth_${authority.id}" class="form-check-label">${authority.authorityName}</label>
                            </div>
                        </#list>
                        <span id="authorityError" class="text-danger"></span>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('createRoleModal')">Закрыть</button>
                    <button type="button" class="btn btn-success" onclick="createRole()">Создать</button>
                </div>
            </div>
        </div>
    </div>

    <script src="/js/script.js"></script>
</@layout.layout>