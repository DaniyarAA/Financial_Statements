<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as main>

<@main.layout>
    <div class="container">
        <h1>Создать таск</h1>
        <form action="/tasks/create" method="post">
            <#if _csrf??>
                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                       value="${(_csrf.token)!'csrf-token'}"/>
            </#if>
            <div class="mb-3">
                <label for="category" class="form-label">Тип документа</label>
                <select class="form-select" id="documentType" name="documentTypeId">
                    <#if categories??>
                        <#list documentTypeDtos as documentType>
                            <option value="${documentType.id}">${documentType.name}</option>
                        </#list>
                    <#else>

                    </#if>

                </select>
            </div>

            <button type="submit" class="btn btn-primary">Create</button>
        </form>
    </div>
</@main.layout>