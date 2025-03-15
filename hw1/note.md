# Note
輸入的每行會先標記出第幾行，並輸出那行
接著根據格式輸出token
結尾需要使用dump輸出symbol table中儲存的identifier


- [x] symbol table
- [x] comment
- [x] 再每行結束時printf該行
- [ ] Token

## Symbol Table
Symbol Table被用來儲存identifier
需要實作三個功能：
- create()：創建一個新的symbol table
- insert(s)：插入s到symbol talbe的新的實體，並且返回index
- lookup(s)：返回一個實體的string "s"的index，否則回傳nil
- dump()：印出symbol table 的中所有的實體，並返回實體的Index

## Maro call
- token(String)：用來標記
- tokenInteger(String , Integer)：第一個String用來標記，第二個參數用來輸入
- tokenString(String , String)：第一個String 用來標記，第二個是輸入

## Comment
這部分需要實作兩種註解，單行與多行註解都要



## 作法
- Symbol Table使用hash + link list實作
- 行判斷方式使用\n判斷

