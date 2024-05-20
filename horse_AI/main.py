import horseresults_scrape
import peds_scrape
import results_scrape
import return_scrape

race_id_list = []
for place in range(1, 11, 1):
    for kai in range(1, 7, 1):
        for day in range(1, 13, 1):
            for r in range(1, 13, 1):
                race_id = "2023" + str(place).zfill(2) + str(kai).zfill(2) + str(day).zfill(2) + str(r).zfill(2)
                race_id_list.append(race_id)

results = Results.scrape(race_id_list)
results.to_pickle('results.pickle')
results = pd.read_pickle('results.pickle')

horse_id_list = results['horse_id'].unique()
horse_results = HorseResults.scrape(horse_id_list)
horse_results #jupyterで出力

horse_results.to_pickle('horse_results.pickle')

peds = Peds.scrape(horse_id_list)
peds
peds.to_pickle('peds.pickle')

return_tables = Return.scrape(horse_id_list)
return_tables
return_tables.to_pickle('return_tables.pickle')