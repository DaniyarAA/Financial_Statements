<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="change-login-password-card card mx-auto mt-5 w-50">
        <div class="card-header text-black border-0">
            <h5 class="card-title">Изменение логина и пароля</h5>
        </div>
        <div class="card-body">
            <form id="changeLoginPasswordForm" method="post">
                <#if _csrf??>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                           value="${(_csrf.token)!'csrf-token'}"/>
                </#if>

                <div class="mb-3">
                    <label for="newUsername" class="form-label">Новый логин</label>
                    <input type="text" id="newUsername" name="newUsername" class="form-control"
                           placeholder="Введите новый логин" required>
                    <div id="loginErrorMessage" class="text-danger small mt-1"></div>
                </div>

                <div class="mb-3">
                    <label for="newPassword" class="form-label">Новый пароль</label>
                    <div class="input-group">
                        <input type="password" id="newPassword" name="newPassword" class="form-control"
                               placeholder="Введите новый пароль" required>
                        <button type="button" class="btn btn-outline-secondary" id="toggleNewPassword">
                            <i class="bi bi-eye-slash" id="newPasswordEyeIcon"></i>
                        </button>
                    </div>
                    <div id="passwordError" class="error-message"></div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Подтвердите пароль</label>
                    <div class="input-group">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               placeholder="Повторите новый пароль" required>
                        <button type="button" class="btn btn-outline-secondary" id="toggleConfirmPassword">
                            <i class="bi bi-eye-slash" id="confirmPasswordEyeIcon"></i>
                        </button>
                    </div>
                    <div id="passwordErrorMessage" class="text-danger small mt-1"></div>
                </div>
            </form>
        </div>

        <div class="d-flex justify-content-center align-items-center modal-footer border-0">
            <button type="button" class="btn btn-success px-5" onclick="saveLoginAndPassword()">
                <i class="bi bi-check2"></i>
            </button>
        </div>
    </div>

    <script src="/js/changeCredentials.js"></script>
</@layout.layout>