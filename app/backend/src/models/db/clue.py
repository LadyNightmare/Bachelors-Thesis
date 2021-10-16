from sqlalchemy import Integer, DateTime, String, Column, ForeignKey, Numeric

from models.db import Base


class Clue(Base):
    __tablename__ = 'clue'

    id = Column(Integer, primary_key=True)
    father_test = Column(Integer, ForeignKey('test.id'))
    start_timestamp = Column(DateTime, nullable=False)
    end_timestamp = Column(DateTime, nullable=True)
    user_id = Column(String, nullable=False)
    file = Column(String, nullable=True)
    test_type = Column(String, nullable=False)
    result = Column(String, nullable=True)
    percentage = Column(Numeric, nullable=True)

    def __init__(self, father_test, start_timestamp, end_timestamp, user_id, file, test_type, result, percentage):
        self.father_test = father_test
        self.start_timestamp = start_timestamp
        self.end_timestamp = end_timestamp
        self.user_id = user_id
        self.file = file
        self.test_type = test_type
        self.result = result
        self.percentage = percentage

    def __str__(self):
        return f'Clue ({self.father_test}, {self.start_timestamp}, {self.end_timestamp}, {self.user_id}, ' \
               f'{self.file}, {self.test_type}, {self.result}, {self.percentage})'
