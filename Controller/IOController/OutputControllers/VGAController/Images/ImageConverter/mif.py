from typing import List
from MifEntry import MifEntry
import difflib


class Mif:

    def __init__(self, *, width=1):
        self.__contents: List[MifEntry] = []
        self.__width = width
        self.__string = None

    def add(self, item: MifEntry):
        self.__contents.append(item)

    def index_of(self, item: MifEntry) -> int:
        try:
            return self.__contents.index(item)
        except ValueError:
            return -1

    def build_line(self, entry_num: int, value: str) -> str:
        return """{:s} """.format(value)

    def get_num_entries(self):
        return len(self.__contents)

    def get_closest(self, val, rebuild=False):
        if self.__string is None or rebuild:
            self.__string = map(lambda x: str(x), self.__contents)
        return difflib.get_close_matches(str(val), self.__string, 1, 0.1)

    def sort(self):
        self.__contents.sort()

    def __str__(self):
        return  ''.join([self.build_line(i, str(x)) for i, x in enumerate(self.__contents)]) \

