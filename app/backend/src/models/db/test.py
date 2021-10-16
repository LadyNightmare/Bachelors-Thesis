from sqlalchemy import Column, DateTime, Integer, String
from sqlalchemy.orm import relationship

from models.db import Base


class Test(Base):
    __tablename__ = 'test'

    id = Column(Integer, primary_key=True)
    start_timestamp = Column(DateTime, nullable=False)
    end_timestamp = Column(DateTime, nullable=True)
    user_id = Column(String, nullable=False)
    result = Column(String, nullable=True)
    clues = relationship("Clue")

    def __init__(self, start_timestamp, end_timestamp, user_id, result):
        self.start_timestamp = start_timestamp
        self.end_timestamp = end_timestamp
        self.user_id = user_id
        self.result = result

    def __str__(self):
        return f'Test ({self.start_timestamp}, {self.end_timestamp}, {self.user_id}, {self.result})'
