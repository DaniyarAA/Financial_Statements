<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <div class="container p-3">
        <div class="main-content">
            <!-- Companies Table Container -->
            <div class="table-container company-table">
                <div class="table-wrapper">
                    <table class="table-main">
                        <thead>
                        <tr class="company-column-tr">
                            <th class="company-column-th">Компании</th>
                        </tr>
                        </thead>
                        <tbody>
                        <#list list as company>
                            <tr class="table-striped-row">
                                <td class="company-columns">${company.name}</td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Container under Companies Table -->
                <div class="pagination-container">
                    <#if currentPage != 0>
                        <a href="?page=${currentPage - 1}&size=7" class="">
                            <div class="button-container">
                                <img alt="Arrow" src="/images/arrow-down.png" style="max-width: 70px; max-height: 70px; rotate: 180deg">
                            </div>
                        </a>
                    </#if>
                    <#if currentPage == totalPages - 1>
                    <#else>
                        <a href="?page=${currentPage + 1}&size=7" class="">
                            <div class="button-container">
                                <img alt="Arrow" src="/images/arrow-down.png" style="max-width: 70px; max-height: 70px;">
                            </div>
                        </a>
                    </#if>


                </div>
            </div>

            <div class="table-container tasks-table">
                <div class="table-wrapper">
                    <table class="table-main">
                        <thead>
                        <tr class="year-month-column">
                                <#list monthsMap?keys as yearMonth>
                                    <th class="year-month-th">${monthsMap[yearMonth]}</th>
                                </#list>
                        </tr>
                        </thead>
                        <tbody>
                        <#list list as company>
                            <tr class="table-striped-row task-columns">
                                <#list monthsMap?keys as yearMonth>
                                    <td>
                                        <#if tasksByYearMonthAndCompany[yearMonth]?? && tasksByYearMonthAndCompany[yearMonth][company.id?string]??>
                                            <div class="task-buttons">
                                                <#list tasksByYearMonthAndCompany[yearMonth][company.id?string] as task>
                                                    <button
                                                            class=" task-button"
                                                            onclick="showTaskDetails(this)"
                                                            data-task-id="${task.id}"
                                                            data-document-type="${task.documentTypeName}"
                                                            data-start-date="${task.startDateTime}"
                                                            data-end-date="${task.endDateTime}"
                                                            data-company-inn="${task.company.inn}"
                                                            data-company-name="${task.company.name}"
                                                            data-description="${task.description}"
                                                            data-amount="${task.amount}"
                                                            data-status="${task.statusId}">
                                                        ${task.documentTypeName}
                                                        <div class="<#if task.isCompleted>completed<#else>pending</#if> button-alert" style="<#if task.isCompleted>color: red</#if>">

                                                        </div>
                                                    </button>
                                                </#list>
                                            </div>
                                        <#else>
                                            <span class="no-tasks">Нет задач</span>
                                        </#if>
                                    </td>
                                </#list>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="task-details" class="task-details">
                <input type="hidden" id="csrfToken" value="${(_csrf.token)!'csrf-token'}"/>
                <div class="task-details-header">
                    <h5>Подробнее</h5>
                </div>

                <div id="task-content">

                </div>
            </div>
        </div>
    </div>


    <script>
        const taskStatusDtos = ${taskStatusDtosJson?no_esc};
    </script>
    <script src="/js/tasks/list.js"></script>

    <style>
        .container {
            padding: 1rem;
            transition: all 0.3s ease;
        }
        .main-content {
            display: flex;
            width: 100%;
        }

        .table-container {
            /*box-shadow: -4px -4px 8px rgba(0, 0, 0, 0.2), 4px -4px 8px rgba(0, 0, 0, 0.2), 0px -4px 8px rgba(0, 0, 0, 0.2);*/
        }
        .company-table {
            width: 250px;

            margin-right: 5px;
            background-color: #d9d9d9;
        }

        .company-column-tr{
            background-color: #ffffff;
            height: 61px;
        }
        .tasks-table {
            width: 75%;
            background-color: #d9d9d9;
            margin-right: 10px;
        }

        .year-month-column {
            background-color: #ffffff;
            height: 61px;
        }

        .table-wrapper {
            width: 100%;
            margin-bottom: 1rem;
            height: 669px;
            max-height: 669px;
        }

        .table-main {
            width: 100%;
            margin-bottom: 20px;

        }

        .table-main th {
            /*border: 3px solid #fff;*/
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #dee2e6;

            /*height: 80px;*/
        }

        .table-main td {
            text-align: center;
            border-bottom: 3px solid #a4a4a4;
            box-shadow: 0 4px 2px -2px #a4a4a4;

        }



        .table-main tbody {
        }
        .table-main {
            background-color: #d9d9d9;

        }

        .company-columns {
            /*width: 100%;*/
            text-align: center;
            height: 52px;
        }
        .task-columns {
            height: 52px;

        }

        .table-striped-row:nth-child(odd) {
            background-color: #d9d9d9;

        }
        .table-striped-row:nth-child(even) {
            background-color: #ffffff;
        }
        /*.year-month-column:nth-child(odd) {*/
        /*    background-color: #d9d9d9;*/
        /*}*/
        /*.year-month-column:nth-child(even) {*/
        /*    background-color: #ededed;*/
        /*}*/

        .task-buttons {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
        .task-buttons button {
            position: relative;
            font-size: 12px;
            border: 1px solid #ffffff;
            border-radius: 4px;
            box-shadow: -4px -4px 8px rgba(0, 0, 0, 0.2), 4px -4px 8px rgba(0, 0, 0, 0.2), 0px -4px 8px rgba(0, 0, 0, 0.2);
        }
        .button-alert {
            position: absolute;

        }

        .completed {
            background-color: green;
        }

        .pending {
            background-color: red;
        }

        .task-details {
            width: 0;
            overflow: hidden;
            padding: 0;
            transition: width 0.3s ease, padding 0.3s ease;
        }

        .container.with-details .task-details {
            width: 40%;
            border: 1px solid #dee2e6;
        }

        .no-tasks {
            font-style: italic;
            color: #6c757d;
        }

        .pagination-container {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .button-container {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 244px;
            height: 70px;
            background-color: #f9f9f9;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .icon-circle {
            width: 48px;
            height: 48px;
            border: 4px solid #000;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .icon-arrow {
            width: 0;
            height: 0;
            border-left: 10px solid transparent;
            border-right: 10px solid transparent;
            border-top: 12px solid #000;
            margin-top: -3px;
        }

        .task-button {
            width: 133px;
            height: 45px;
        }


        .test {

        }

        #task-content {
            padding: 5px;
            background-color: #d9d9d9;
            width: 100%;
            height: 100%;
        }
        .task-details-header {
            height: 61px;
            background-color: #ffffff;
            display: flex;
            align-items: center;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            color: #333;
            justify-content: center;
        }

        #task-edit-form p {
            font-size: 16px;
            margin: 5px 0;
            color: #333;
        }

        #task-edit-form strong {
            color: #666;
            font-style: italic;
        }

        #amount-text, #status-text {
            font-weight: bold;
            color: #000;
        }

        .btn-link {
            color: #888;
            font-size: 14px;
            padding: 0;
            text-decoration: none;
        }

        .btn-link:hover {
            color: #333;
        }

        textarea, input[type="text"] {
            width: 100%;
            border-radius: 5px;
            border: 1px solid #ccc;
            padding: 10px;
            font-size: 16px;
            margin-bottom: 10px;
        }

        button[type="submit"] {
            display: inline-block;
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button[type="submit"]:hover {
            background-color: #45a049;
        }

        .task-info {
            display: flex;
            margin-bottom: 20px;
        }

        .labels {
            text-align: right;
            width: 30%;
            padding-right: 10px;
            font-size: 14px;
            font-style: italic;
            color: #555;
        }

        .values {
            text-align: left;
            width: 70%;
            font-size: 16px;
            font-weight: 400;
            color: #000;
        }

        .task-info p {
            margin: 5px 0;
        }


    </style>



</@layout.layout>
