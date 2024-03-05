'''
file: database.py
Author: Mohak Vaswani
'''

from sqlalchemy import Column, Integer, String, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Mapped, mapped_column
from typing import Union

Base = declarative_base()

class APK(Base):
    __tablename__ = "apk"
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    app_name: Mapped[Union[str, None]] = mapped_column(String)
    uuid: Mapped[str] = mapped_column(String)
    variable: Mapped[str] = mapped_column(String)
    path: Mapped[str] = mapped_column(String)

class APKRepository:
    def __init__(self):
        engine = create_engine('sqlite:///APK.db')
        SessionLocal = sessionmaker(bind=engine)
        self.session = SessionLocal()  # Creates a session instance
        Base.metadata.create_all(engine)

    # Make sure to close the session when done, e.g., by adding a close method:
    def close_session(self):
        self.session.close()

    def insert_apk(self, app_name, uuid, variable, path):
        new_apk = APK(app_name=app_name, uuid=uuid, variable=variable, path=path)
        self.session.add(new_apk)
        self.session.commit()
        return new_apk

    def get_apk_by_id(self, apk_id):
        return self.session.query(APK).filter(APK.id == apk_id).first()

    def update_apk(self, apk_id, **kwargs):
        apk = self.session.query(APK).filter(APK.id == apk_id).first()
        if apk:
            for key, value in kwargs.items():
                setattr(apk, key, value)
            self.session.commit()
            return apk
        return None

    def delete_apk(self, apk_id):
        apk = self.session.query(APK).filter(APK.id == apk_id).first()
        if apk:
            self.session.delete(apk)
            self.session.commit()
            return True
        return False

