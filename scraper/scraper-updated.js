import gplay from "google-play-scraper";
import fs from 'fs';
import csv from 'csv-parser';

let information = [];
let appCounter = 0; // Counter for the number of apps processed

async function saveListToFile() {
    const path = "./temp.csv";
    const readStream = fs.createReadStream(path);
    const promises = [];

    readStream.pipe(csv())
        .on("data", (row) => {
            const promise = processRow(row);
            promises.push(promise);
        })
        .on("end", async () => {
            await Promise.all(promises);
            fs.writeFileSync('resultBluetooth-no-perms.json', JSON.stringify(information, null, 2));
            console.log(`Total number of apps processed: ${appCounter}`); // Log the total count
        });
}

async function processRow(row) {
    try {
        const list = await gplay.search({ term: `${row["product"]}` });
        for (const value of list) {
            let permissions = await gplay.permissions({ appId: value["appId"] });

            if (permissions.some(permission => permission.permission.includes('Bluetooth'))) {
                appCounter++; 
                const values = {
                    "name": value["title"],
                    "description": value["summary"]
                    //"permissions": permissions
                };
                information.push(values);

                try {
                    const similarList = await gplay.similar({ appId: value["appId"] });
                    for (const similarApp of similarList) {
                        let permissions_similar = await gplay.permissions({ appId: similarApp["appId"] });

                        if (permissions_similar.some(permission => permission.permission.includes('Bluetooth'))) {
                            appCounter++; 
                            const similarAppInfo = {
                                "name": similarApp["title"],
                                "appId": similarApp["appId"]
                                //"permissions": permissions_similar
                            };
                            information.push(similarAppInfo);
                        }
                    }
                } catch (error) {
                    console.error(`Similar apps for ${value["title"]} not found`);
                }
            }
        }
    } catch (error) {
        console.error(`Cannot find app for developer ${row["product"]}`);
    }
}


saveListToFile().then(() => {
    console.log("done");
});
