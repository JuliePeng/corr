import os
import jinja2
from dataprovider.qconnection import QConnection


def render(tpl_path, context):
    path, filename = os.path.split(tpl_path)
    return jinja2.Environment(
        loader=jinja2.FileSystemLoader(path or './')
    ).get_template(filename).render(context)


def get_name(first_name, last_name):
    return {'firstname': first_name,
            'lastname': last_name}


def get_top10_corr_tbl():
    data = QConnection.query(
        'update t1: (string t1), t2: string t2 from 0!(10#`corr xdesc corr),(-10#`corr xdesc corr)')
    table = list(data.values)
    table.insert(0, data.columns)
    return {'table': table}

def get_hist_line(ticker):
    data = QConnection.query('0!1_select date, (price - prev price)%prev price from lastprice where ticker=`'+ticker)
    line_chart = []
    for row in data.values:
        line_chart.append({'x': (8611 + row[0]) * 100000000, 'y': row[1]})
    return {'key': ticker, 'values': line_chart}


def draw_hist_lines():
    lines=[]
    max_corr_ticker = QConnection.query('select t1,t2 from corr where corr=max abs(corr)')
    lines.append(get_hist_line(max_corr_ticker.values[0][0]))
    lines.append(get_hist_line(max_corr_ticker.values[0][1]))
    return {'histchart':lines}


template_context = {}
template_context.update(get_name('Lombard','Odier'))
template_context.update(get_top10_corr_tbl())
template_context.update(draw_hist_lines())

result = render(r'C:\Users\pzlap\PycharmProjects\CorrReport\template\template.html', template_context)

with open(r'C:\Users\pzlap\PycharmProjects\CorrReport\export\final.html', 'w') as f:
    f.write(result)
