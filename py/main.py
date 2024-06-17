import json
import logging
import socket

import ocr

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(name)s - %(message)s')
handler = logging.StreamHandler()
handler.setFormatter(formatter)
logger.addHandler(handler)

if __name__ == "__main__":
    host = '0.0.0.0'
    port = 9999

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))
    server_socket.listen(5)

    logger.info(f"服务器正在监听 {host}:{port}")

    while True:
        client_socket, client_address = server_socket.accept()
        logger.info(f"接受来自 {client_address} 的连接")

        data = client_socket.recv(1024)  # 指定最大接收数据的大小
        logger.info(f"接收到数据: {data.decode('utf-8')}")

        s = data.decode('utf-8')
        url = s.split('#')[-1]
        destination = url.split('/')[-1]
        length_threshold = [800, 300]
        block_count = int(s[0])
        ret = ocr.ocr(url, destination, length_threshold, block_count)
        
        json_data = json.dumps(ret)
        client_socket.send(json_data.encode('utf-8'))
        logger.info(f"发送数据: {json_data}")

#        send_data = '''[[[["8+", "1", "0"], ["192x", "1", "0"], ["2/", "1", "0"], ["90x", "1", "0"], ["12+", "0",
#        "1"], [" ", "1", "0"]], [[" ", "1", "1"], [" ", "1", "0"], [" ", "1", "1"], [" ", "1", "0"], ["1-", "1", "0"],
#        [" ", "1", "1"]], [[" ", "0", "1"], [" ", "1", "0"], ["1-", "1", "0"], [" ", "1", "1"], [" ", "1", "1"], ["4-",
#        "1", "0"]], [["2-", "1", "0"], [" ", "1", "1"], [" ", "1", "1"], ["2/", "1", "0"], ["4x", "1", "0"], [" ", "1",
#        "1"]], [[" ", "1", "1"], ["13+", "1", "0"], ["7+", "1", "0"], [" ", "1", "1"], [" ", "1", "1"], ["3/", "1",
#        "0"]], [[" ", "0", "1"], [" ", "1", "1"], [" ", "1", "1"], ["6x", "0", "1"], [" ", "1", "1"], [" ", "1", "1"]]],
#        [["2", "4", "1", "6", "5", "3"], ["6", "1", "2", "5", "3", "4"], ["4", "6", "5", "3", "2", "1"], ["3", "2",
#        "6", "4", "1", "5"], ["1", "5", "3", "2", "4", "6"], ["5", "3", "4", "1", "6", "2"]]]'''
#        client_socket.send(send_data.encode('utf-8'))
#        logger.info(f"发送数据: {send_data}")

        client_socket.close()
