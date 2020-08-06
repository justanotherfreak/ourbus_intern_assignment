import pandas as pd

data = pd.read_csv("/home/db/Downloads/pehchan_kaun.csv")
dat = data.to_numpy()

#list to store transformed data
list1 = []
for i in dat:
    le = [] #list to store data of each row of transformed data
    fd = ld = 0  #variable to store first absent day and last absent day respectively
    flag = 0 #flag to check if first absent day has been found
    for j in range(1,11):
        if i[j] == '.':

            # Find first absent day
            if flag == 0:
                fd = j
                flag = 1
            #update last absent day every time a person is absent 
            ld = j

    le.append(fd)
    le.append(ld)

    #bolo_kab_kab conditions
    if fd == 0:
        le.append('wow')
    elif fd == ld:
        le.append('oh!')
    else:
        le.append('shame-shame')

    #Logic to create full name without extra spaces
    name_list = []
    if str(i[0]) != 'nan':
        name_list.append(i[0])
    if str(i[-2]) != 'nan':
        name_list.append(i[-2])
    if str(i[-1]) != 'nan':
        name_list.append(i[-1])
    le.append(' '.join(name_list))


    list1.append(le)

#list to dataframe
df = pd.DataFrame(list1, columns= ['_1st_absent_on','_last_absent_on','bolo_kab_kab','full_name'])

#store as csv
df.to_csv('transformed.csv', index = False)
print(df)


            

            
