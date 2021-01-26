import json, csv, pyperclip

fp = "data.csv"
procedureName = "createAccount"

data_columns = {
    "email": "string",
    "password": "string",
    "title": "string",
    "first_name": "string",
    "last_name": "string",
    "address": "string",
    "country": "string",
    "phone_num": "string",
    "birth_date": "string",
}

def buildProcedureSql(procedureName, dcol, data):
    res = {}
    sres = "EXEC "+procedureName
    for k,v in dcol.items():
        if v == "uuid": res[k] = "NEWID()"
        elif v == "string": res[k] = "'"+data[k]+"'"
        elif v == "number": res[k] = data[k]
        sres +=  " @" + k + "=" + res[k] + ","
    sres = sres.rstrip(',')+";"
    return sres

with open(fp) as csvFile:
    csvReader = csv.DictReader(csvFile)
    res = []
    for row in csvReader:
        res.append(buildProcedureSql(procedureName, data_columns, row))
    cp = '\n'.join(res)
    print(cp)
    pyperclip.copy(cp)