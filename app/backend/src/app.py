from datetime import datetime

from flask import Flask
from flask import request
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from constants import LIMIT, NEXT_CLUES, VIDEOS_PATH
from methods import get_percentage
from models.db.clue import Clue
from models.db.test import Test

docker_db_uri = "database:5432"
db_uri = "localhost:5432"

engine = create_engine(f"postgresql://root:root@{docker_db_uri}/are_u_drunk")

Session = sessionmaker(engine, expire_on_commit=False)

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024


@app.route('/smoothleft', methods=['POST'])
def smooth_left():
    user = request.form['user']
    father_test_id = int(request.form['father_test_id'])
    time = datetime.utcnow()
    filename = f"{user}-{time.strftime('%Y-%m-%d %H:%M:%S')}-smoothleft.mp4"
    request.files['media'].save(filename)
    perc = get_percentage(filename, 'left')
    if perc > LIMIT:
        return_result = "pass"
    elif perc == 0:
        return_result = "undetected"
    else:
        return_result = "fail"
    _insert_into_db(father_test_id=father_test_id, return_result=return_result, user=user, filename=filename,
                    current_clue_type="smoothleft", time=time, percentage=perc)
    return {'result': return_result}


@app.route('/smoothright', methods=['POST'])
def smooth_right():
    user = request.form['user']
    father_test_id = int(request.form['father_test_id'])
    time = datetime.utcnow()
    filename = f"{user}-{time.strftime('%Y-%m-%d %H:%M:%S')}-smoothright.mp4"
    request.files['media'].save(filename)
    perc = get_percentage(filename, 'right')
    if perc > LIMIT:
        return_result = "pass"
    elif perc == 0:
        return_result = "undetected"
    else:
        return_result = "fail"
    _insert_into_db(father_test_id=father_test_id, return_result=return_result, user=user, filename=filename,
                    current_clue_type="smoothright", time=time, percentage=perc)
    return {'result': return_result}


@app.route('/maximumleft', methods=['POST'])
def maximum_left():
    user = request.form['user']
    father_test_id = int(request.form['father_test_id'])
    time = datetime.utcnow()
    filename = f"{user}-{time.strftime('%Y-%m-%d %H:%M:%S')}-maximumleft.mp4"
    request.files['media'].save(filename)
    perc = get_percentage(filename, 'left')
    if perc > LIMIT:
        return_result = "pass"
    elif perc == 0:
        return_result = "undetected"
    else:
        return_result = "fail"
    _insert_into_db(father_test_id=father_test_id, return_result=return_result, user=user, filename=filename,
                    current_clue_type="maximumleft", time=time, percentage=perc)
    return {'result': return_result}


@app.route('/maximumright', methods=['POST'])
def maximum_right():
    user = request.form['user']
    father_test_id = int(request.form['father_test_id'])
    time = datetime.utcnow()
    filename = f"{VIDEOS_PATH}/{user}-{time.strftime('%Y-%m-%d %H:%M:%S')}-maximumright.mp4"
    request.files['media'].save(filename)
    perc = get_percentage(filename, 'right')
    if perc > LIMIT:
        return_result = "pass"
    elif perc == 0:
        return_result = "undetected"
    else:
        return_result = "fail"
    _insert_into_db(father_test_id=father_test_id, return_result=return_result, user=user, filename=filename,
                    current_clue_type="maximumright", time=time, percentage=perc)
    return {'result': return_result}


@app.route('/onsetleft', methods=['POST'])
def onset_left():
    user = request.form['user']
    father_test_id = int(request.form['father_test_id'])
    time = datetime.utcnow()
    filename = f"{user}-{time.strftime('%Y-%m-%d %H:%M:%S')}-onsetleft.mp4"
    request.files['media'].save(filename)
    perc = get_percentage(filename, 'left')
    if perc > LIMIT:
        return_result = "pass"
    elif perc == 0:
        return_result = "undetected"
    else:
        return_result = "fail"
    _insert_into_db(father_test_id=father_test_id, return_result=return_result, user=user, filename=filename,
                    current_clue_type="onsetleft", time=time, percentage=perc)
    return {'result': return_result}


@app.route('/onsetright', methods=['POST'])
def onset_right():
    user = request.form['user']
    father_test_id = int(request.form['father_test_id'])
    time = datetime.utcnow()
    filename = f"{user}-{time.strftime('%Y-%m-%d %H:%M:%S')}-onsetright.mp4"
    request.files['media'].save(filename)
    perc = get_percentage(filename, 'right')
    if perc > LIMIT:
        return_result = "pass"
    elif perc == 0:
        return_result = "undetected"
    else:
        return_result = "fail"
    _insert_into_db(father_test_id=father_test_id, return_result=return_result, user=user, filename=filename,
                    current_clue_type="onsetright", time=time, percentage=perc)
    return {'result': return_result}


@app.route('/initialize', methods=['POST'])
def initialize():
    user = request.form['user']
    time = datetime.utcnow()
    with Session() as session:
        test = Test(start_timestamp=time, end_timestamp=None, user_id=user, result=None)
        session.add(test)
        session.flush()
        clue = Clue(father_test=test.id, start_timestamp=time, end_timestamp=None, user_id=user, file=None,
                    test_type="smoothleft", result=None, percentage=None)
        session.add(clue)
        session.commit()
        return {'father_id': test.id}


def _insert_into_db(father_test_id, return_result, user, filename, current_clue_type, time, percentage):
    with Session() as session:
        parent_test = session.query(Test).get(father_test_id)
        parent_test.end_timestamp = time
        current_clue = session.query(Clue).filter_by(father_test=father_test_id, test_type=current_clue_type).first()
        current_clue.end_timestamp = time
        current_clue.file = filename
        current_clue.result = return_result
        if return_result == "undetected":
            parent_test.result = "fail"
        else:
            current_clue.percentage = percentage
            wrong_clues = session.query(Clue).filter_by(father_test=father_test_id, result='fail').count()
            app.logger.critical("wrong clues: %s", wrong_clues)
            if wrong_clues < 2:
                new_clue = Clue(father_test=father_test_id, start_timestamp=time, end_timestamp=None, user_id=user,
                                file=None, test_type=NEXT_CLUES[current_clue_type], result=None, percentage=None)
                app.logger.critical("creando clue %s", new_clue)
                session.add(new_clue)
            else:
                parent_test.result = "fail"
        session.commit()
