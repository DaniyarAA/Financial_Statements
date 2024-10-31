<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as main>

<@main.layout>
    <div class="container mt-4">
        <h2 class="text-center mb-4">Список задач по месяцам и годам</h2>

        <!-- Список месяцев и годов -->
        <div class="mb-3">
            <h5>Выберите месяц:</h5>
            <div class="btn-group" role="group">
                <#list monthsMap?keys as monthYear>
                    <a class="btn btn-outline-primary" href="?monthYear=${monthYear}">
                        ${monthsMap[monthYear]}
                    </a>
                </#list>
            </div>
        </div>

        <!-- Список задач за выбранный месяц и год -->
        <div class="row">
            <#list tasks as task>
                <div class="col-md-4 mb-3">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">${task.user.name}</h5>
                            <p class="card-text">
                                ${task.description}
                            </p>
                        </div>
                    </div>
                </div>
            </#list>
        </div>
    </div>
</@main.layout>
