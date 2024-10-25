<#import "../layout.ftlh" as loginForm>
<#import "/spring.ftl" as spring>

<@loginForm.layout>
    <div class="container mt-5">
        <div class="card p-4 bg-dark text-white" style="width: 350px; margin: 0 auto;">
            <div class="text-center mb-4">
                <h2 class="mt-2">Exam9</h2>
            </div>

            <form id="loginForm" action="/login" method="post">
                <#if _csrf??>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                           value="${(_csrf.token)!'csrf-token'}"/>

                </#if>
                <div class="mb-3">
                    <input type="text" id="form2Example1" class="form-control" name="username"/>

                    <label class="form-label" for="form2Example1">ID</label>

                </div>

                <div class="mb-3">
                    <input type="password" id="form2Example2" class="form-control" name="password"/>

                    <label class="form-label" for="form2Example2">Password</label>

                </div>

                <button type="submit" class="btn btn-outline-light w-100">Sign in</button>
            </form>
        </div>
    </div>
</@loginForm.layout>

