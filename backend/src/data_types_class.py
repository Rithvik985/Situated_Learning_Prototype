from typing import Literal, Optional, Union, TextIO, List,Dict, Any, Literal
from pydantic import BaseModel, Field
from enum import Enum
from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class Assignment(Base):
    __tablename__ = 'assignments'
    id = Column(Integer, primary_key=True)
    course_id = Column(String(255), nullable=False)
    course_title = Column(String(255), nullable=False)
    instructor_name = Column(String(255), nullable=False)
    content = Column(Text, nullable=False)
    topic = Column(String(100), nullable=False)

class QueryRequest(BaseModel):
    userquery: str
    query_context: Optional[str] = None  

class Credentials(BaseModel):
    deployment: Literal["Weaviate", "Docker", "Local"]
    url: str
    key: str

class ConfigSetting(BaseModel):
    type: str
    value: str | int
    description: str
    values: list[str]

class RAGComponentConfig(BaseModel):
    name: str
    variables: list[str]
    library: list[str]
    description: str
    config: dict[str, ConfigSetting]
    type: str
    available: bool

class RAGComponentClass(BaseModel):
    selected: str
    components: dict[str, RAGComponentConfig]

class RAGConfig(BaseModel):
    Reader: RAGComponentClass
    Chunker: RAGComponentClass
    Embedder: RAGComponentClass
    Retriever: RAGComponentClass
    Generator: RAGComponentClass

class DocumentFilter(BaseModel):
    title: str
    uuid: str


class QueryPayload(BaseModel):
    query: str
    RAG: dict[str, RAGComponentClass]
    labels: list[str]
    documentFilter: list[DocumentFilter]
    credentials: Credentials
