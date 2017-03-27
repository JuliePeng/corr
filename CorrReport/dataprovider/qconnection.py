from qpython import qconnection
from pandas import DataFrame as df
import logging
logger=logging.getLogger(__name__)

class QConnection(object):
    host='localhost'
    port=2000

    @staticmethod
    def query(query_cmd):
        try:
            logger.info("Getting data with query: {0}".format(query_cmd))
            q = qconnection.QConnection(host=QConnection.host, port=QConnection.port)
            q.open()
            data = q.sync(query_cmd)
            q.close()
            data=df(data)
            if 't1' in data:
                data['t1']=[x.decode('utf-8') for x in data['t1']]
                data['t2'] = [x.decode('utf-8') for x in data['t2']]
            if 'ticker' in data:
                data['ticker'] = [x.decode('utf-8') for x in data['ticker']]
            return data
        except:
            logger.error("Failed in getting data")






