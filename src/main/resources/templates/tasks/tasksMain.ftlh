<#import "/spring.ftl" as spring>
<#import "../layout.ftlh" as main>

<@main.layout>
    <div class="container font-weight-bold text-black mt-5" style="color: white">
        <h2 class="text-center mb-4">Таски</h2>

        <div class="mb-4">
            <label for="statusFilter" class="font-weight-bold text-black mb-1">Статус:</label>
            <select id="statusFilter" class="form-select mb-2" onchange="taskFiltering()">
                <option value="">Все</option>
                <option value="сдан">Сдан</option>
                <option value="не сдан">Не сдан</option>
                <option value="просрочен">Просрочен</option>
            </select>

            <label for="documentTypeFilter" class="font-weight-bold text-black mb-1">Тип документа:</label>
            <select id="documentTypeFilter" class="form-select  mb-2" onchange="taskFiltering()">
                <option value="">Все</option>
                <option value="161 форма">161 форма</option>
                <option value="ЕН отчет">ЕН отчет</option>
                <option value="Косвенный налог">Косвенный налог</option>
                <option value="Единый налог (расчет)">Единый налог (расчет)</option>
                <option value="Декларация расчет на прибыль">Декларация расчет на прибыль</option>
                <option value="Инвест">Инвест</option>
                <option value="Импорт косв">Импорт косв</option>
                <option value="Мусор">Мусор</option>
                <option value="Статком">Статком</option>
                <option value="ЭСФ">ЭСФ</option>
                <option value="ЭСФ контроль">ЭСФ контроль</option>
                <option value="НДС">НДС</option>
                <option value="НСП">НСП</option>
            </select>

            <label for="dateFilter" class="font-weight-bold text-black mb-1">Срок выполнения:</label>
            <input type="date" id="dateFilter" class="form-control mb-2" onchange="taskFiltering()">
        </div>

        <table class="table table-hover table-bordered">
            <thead class="table-dark">
            <tr>
                <th scope="col">#</th>
                <th scope="col">Статус</th>
                <th scope="col">С</th>
                <th scope="col">По</th>
                <th scope="col">Тип документа</th>
                <th scope="col">Бухгалтер</th>
            </tr>
            </thead>
            <tbody id="taskTableBody">
            <#list tasks as task>
                <tr class="task-row" data-status="${task.statusId}" data-document-type="${task.documentTypeName}">
                    <th scope="row"><a href="/tasks/${task.id}" class="btn btn-sm btn-warning">${task.id}</a></th>
                    <td>${task.statusId}</td>
                    <td>${dateUtils.formatDateTime(task.from, "dd.MM.yyyy")}</td>
                    <td>${dateUtils.formatDateTime(task.to, "dd.MM.yyyy")}</td>
                    <td>${task.documentTypeName}</td>
                    <td>${task.user.name} ${task.user.surname}</td>
                </tr>
            </#list>
            </tbody>
        </table>
    </div>
<script src="/js/taskFiltering.js"></script>
</@main.layout>