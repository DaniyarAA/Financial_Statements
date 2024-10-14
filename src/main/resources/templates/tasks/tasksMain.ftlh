<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as registerForm>

<@registerForm.layout>
    <div class="container mt-5" style="color: white">
        <h2 class="text-center mb-4">Таски</h2>

        <table class="table table-hover table-bordered">
            <thead class="table-dark">
            <tr>
                <th scope="col">#</th>
                <th scope="col">Статус</th>
                <th scope="col">Дата</th>
                <th scope="col">Время</th>
                <th scope="col">Тип документа</th>
                <th scope="col">Бухгалтер</th>
            </tr>
            </thead>
            <tbody>
            <#list tasks as task>
                <tr>
                    <th scope="row"><a href="/tasks/${task.id}" class="btn btn-sm btn-warning">${task.id}</a>
                    </th>
                    <td>${task.status}</td>
                    <td>${task.date}</td>
                    <td>${task.time}</td>
                    <td>${task.documentTypeName}</td>
                    <td>${task.user.name} ${task.user.surname}</td>
                </tr>
            </#list>
            </tbody>
        </table>
    </div>
</@registerForm.layout>