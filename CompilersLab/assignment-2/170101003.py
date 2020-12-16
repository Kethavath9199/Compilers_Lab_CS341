import re

#unused function

with open('input1.txt', 'r') as file1:
    with open('input2.txt', 'r') as file2:
        same = set(file1).intersection(file2)

same.discard('\n')

with open('output.txt', 'w') as file_out:
    for line in same:
        file_out.write(line)


#unused function
import sys

def Factorial(n): # return factorial
    result = 1
    for i in range (1,n):
        result = result * i
    print ("factorial is ",result)
    return result


class Parsing_Java:

#defining variables
    def __init__(self):
        self.classcount = 0
        self.InheritedclassCount = 0
        self.ConstructorsCount = 0
        self.operatorover_count = 0
        self.objects_count = 0
        self.comments_count = 0

        self.TableClass = list()
        self.TableInherited = list()
        self.TypeConstructor = list()
        self.OverloadOperator = list()
        self.TableObject = {}

#removing all comments from the input file
    def RemoveComments(self, FullText):
        def replacer(TextMatching):
            string = TextMatching.group(0)
            if string.startswith('/') or string.startswith('"'):
                return " "
            else:
                return string
        StylePattern = re.compile(r'"(\\.|[^\\"])*"|//.*?$|/\*.*?\*/', re.DOTALL | re.MULTILINE)
        NoCommentFile = re.sub(StylePattern, replacer, FullText)
        return NoCommentFile

#removing predefined variables from the input file
    def drawbyname(self, FullText):
        def replacer(TextMatching):
            string = TextMatching.group(0)
            if string.startswith('#define'):
                return " "
            else:
                return string
        StylePattern = r'(#define .*?)[\n$]'
        defines = re.findall(StylePattern, FullText)


        NoCommentFile = re.sub(StylePattern, replacer, FullText)
        new_file = NoCommentFile
        for iter in defines:
            x = iter.split(' ')
            print(x)
            pat = r'\b'+x[1]+r'\b'
            repl = ' '.join(x[2:])
            new_file = re.sub(pat, repl, new_file)
        return new_file

#function to calculate total number of lines that contains class in the input file
    def SearcherClass(self, FullText):
        TextLines = FullText.split('\n')
        for line in TextLines:
            line = line + '\n'
            ClassFoundFlag = False
            in_ClassFoundFlag = False
            class_finder = r'(?:(?:|public|final|abstract|private|static|protected)(?:\s+))?(?:class)(?:\s+)([A-Za-z_]\w*)'
            TableClass = re.findall(class_finder, line)

            InheritedClassFinder = r'\bclass\b\s+([A-Za-z_]\w*)\s+(?:extends|implements)\s+'
            TableInherited = re.findall(InheritedClassFinder, line)
            TableClass = list(filter(None, TableClass))
            if len(TableClass) > 0:
                ClassFoundFlag = True
            if len(TableInherited) > 0:
                in_ClassFoundFlag = True
            if ClassFoundFlag or in_ClassFoundFlag:
                self.classcount = self.classcount + 1
            for class_name in TableClass:
                if class_name not in self.TableClass:
                    self.TableClass.append(class_name)

#function to calculate total number of lines that contains inherited class in the input file
    def SearcherInherited(self, FullText):
        TextLines = FullText.split('\n')
        for line in TextLines:
            line = line + '\n'
            LineFlag = False
            InheritedClassFinder = r'\bclass\b\s+([A-Za-z_]\w*)\s+(?:extends|implements)\s+'
            TableInherited = re.findall(InheritedClassFinder, line)
            if len(TableInherited) > 0:
                if LineFlag == False:
                    self.InheritedclassCount = self.InheritedclassCount + 1
                    LineFlag = True

            for class_name in TableInherited:
                if class_name not in self.TableInherited:
                    self.TableInherited.append(class_name)

#function to calculate total number of lines that contains constuctor in the input file
    def FinderConstructor(self, FullText):
        TextLines = FullText.split('\n')
        for line in TextLines:
            line = line + '\n'
            line=' '+line
            ConstructorsFinder = r'(?:|public|private)?\s+([A-Za-z_]\w*)\s*\('
            ConstructorsList = re.findall(ConstructorsFinder, line)
            ConstructorsFinder1 = r'new\s+([A-Za-z_]\w*)\s*\('
            ConstructorsList1 = re.findall(ConstructorsFinder1, line)
            freq = {}
            ConstructorFound = False
            LineFlag = False
            for definition in ConstructorsList:
                if definition in self.TableClass:
                    if definition in freq:
                        freq[definition] = freq[definition] + 1
                    else:
                        freq[definition] = 1

            for definition in ConstructorsList1:
                if definition in self.TableClass:
                    if definition in freq:
                        freq[definition] = freq[definition] - 1

            for key in freq.keys():
                if freq[key] > 0:
                    ConstructorFound = True
                    self.TypeConstructor.append(key)
                if ConstructorFound:
                    if LineFlag == False:
                        self.ConstructorsCount = self.ConstructorsCount + 1
                        LineFlag = True
                        break

#function to calculate total number of lines that contains object in the input file
    def objects_finder(self, FullText):
        TextLines = FullText.split('\n')
        for line in TextLines:
            line = line + '\n'
            FoundObject=False
            LineFlag= False
            for item in self.TableClass:
                item += '\s*(?:\[\])*\s+([A-Za-z_]\w*)\s*(?:\[\])*\s*(?:;|,|=)'
                object_list = re.findall(item, line)
                if len(object_list):
                    FoundObject=True
                    print(object_list)
            if FoundObject:
                if LineFlag == False:
                    self.objects_count = self.objects_count + 1
                    LineFlag = True
    
#function that makes all the above functions run
    def FileAndParseLoader(self, file_name):
        file_name = 'files/' + file_name
        try:
            with open(file_name, 'r') as java_file:
                FileCleaned = self.RemoveComments(java_file.read())
                FileCleaned = self.drawbyname(FileCleaned)
                self.SearcherClass(FileCleaned)
                self.SearcherInherited(FileCleaned)
                self.FinderConstructor(FileCleaned)
                self.objects_finder(FileCleaned)
                self.print_statistics()
                print(self.TableClass)
                print(self.TableObject)
        except FileNotFoundError:
            print('There is no such file!')
            exit(1)

#function to output all the required fields
    def print_statistics(self):
        print('Class definition              : ', self.classcount)
        print('Inherited classe definition    : ', self.InheritedclassCount)
        print('Constructor definition         : ', self.ConstructorsCount)
        print('Objects Definition  : ', self.objects_count)






if __name__ == '__main__':
    class_instance = Parsing_Java()
    file_input = input('Enter the input file name: ')
    class_instance.FileAndParseLoader(file_input)
