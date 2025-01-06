var Cal = function(divId) {
    this.divId = divId;

    this.DaysOfWeek = [
        'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'
    ];

    this.Months = [
        'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];

    var d = new Date();

    this.currMonth = d.getMonth();
    this.currYear = d.getFullYear();
    this.currDay = d.getDate();

    this.showcurr();
};

Cal.prototype.nextMonth = function() {
    if (this.currMonth === 11) {
        this.currMonth = 0;
        this.currYear += 1;
    } else {
        this.currMonth += 1;
    }
    this.showcurr();
};

Cal.prototype.previousMonth = function() {
    if (this.currMonth === 0) {
        this.currMonth = 11;
        this.currYear -= 1;
    } else {
        this.currMonth -= 1;
    }
    this.showcurr();
};

Cal.prototype.showcurr = function() {
    this.showMonth(this.currYear, this.currMonth);
};

Cal.prototype.showMonth = async function(y, m) {
    var d = new Date(),
        firstDayOfMonth = new Date(y, m, 1).getDay() - 1,
        lastDateOfMonth = new Date(y, m + 1, 0).getDate(),
        lastDayOfLastMonth = m === 0 ? new Date(y - 1, 11, 0).getDate() : new Date(y, m, 0).getDate();

    if (firstDayOfMonth < 0) firstDayOfMonth = 6;

    var html = '<table class="calendar-table">';

    html += '<thead><tr>';
    html += '<td class="td-calendar calendar-left"><button id="btnPrev"></button></td>';
    html += '<td class="td-calendar calendar-month-date" colspan="5">' + this.Months[m] + ' ' + y + '</td>';
    html += '<td class="td-calendar calendar-right"><button id="btnNext"></button></td>';
    html += '</tr></thead>';

    html += '<tr class="days">';
    for (var i = 0; i < this.DaysOfWeek.length; i++) {
        html += '<td class="td-calendar">' + this.DaysOfWeek[i] + '</td>';
    }
    html += '</tr>';

    const data = await this.getTaskCounts(y, m + 1);

    var i = 1;
    do {
        var dow = new Date(y, m, i).getDay() - 1;
        if (dow < 0) dow = 6;

        if (dow === 0) {
            html += '<tr>';
        }

        if (i === 1 && dow !== 0) {
            var k = lastDayOfLastMonth - firstDayOfMonth + 1;
            for (var j = 0; j < firstDayOfMonth; j++) {
                html += '<td class="not-current td-calendar">' + k + '</td>';
                k++;
            }
        }

        var chk = new Date();
        var chkY = chk.getFullYear();
        var chkM = chk.getMonth();
        if (chkY === this.currYear && chkM === this.currMonth && i === this.currDay) {
            html += '<td class="today td-calendar">' + i + '</td>';
        } else {
            const taskCount = data[`${y}-${String(m + 1).padStart(2, '0')}-${String(i).padStart(2, '0')}`] || 0;
            let style = 'background-color: white;';

            if (taskCount >= 1 && taskCount <= 2) {
                style = 'background-color: #d0f0c0;';
            } else if (taskCount >= 3 && taskCount <= 5) {
                style = 'background-color: #fffacd;';
            } else if (taskCount >= 6 && taskCount <= 9) {
                style = 'background-color: #f4cccc;';
            } else if (taskCount >= 10) {
                style = 'background-color: #c0c0c0; color: black;';
            }

            html += `<td class="td-calendar" style="${style}">${i}</td>`;
        }

        if (dow === 6) {
            html += '</tr>';
        } else if (i === lastDateOfMonth) {
            var k = 1;
            for (dow; dow < 6; dow++) {
                html += '<td class="not-current td-calendar">' + k + '</td>';
                k++;
            }
        }

        i++;
    } while (i <= lastDateOfMonth);

    html += '</table>';

    document.getElementById(this.divId).innerHTML = html;

    var self = this;
    document.getElementById('btnNext').onclick = function() {
        self.nextMonth();
    };

    document.getElementById('btnPrev').onclick = function() {
        self.previousMonth();
    };
};


Cal.prototype.getTaskCounts = async function(year, month) {
    const yearMonth = { year: year, month: month };
    const csrfToken = document.querySelector('input[name="_csrf"]').value;

    try {
        const response = await fetch('/calendar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': csrfToken
            },
            body: JSON.stringify(yearMonth)
        });

        if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }

        return await response.json();
    } catch (error) {
        console.error('There was a problem with the fetch operation:', error);
        return {};
    }
};

window.onload = function() {
    var c = new Cal("divCal");
    c.showcurr();
}

function getId(id) {
    return document.getElementById(id);
}
