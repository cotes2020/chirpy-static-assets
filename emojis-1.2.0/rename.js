const fs = require("fs");
const path = require("path");

const rename = (folderName, oldPrefix, newPrefix) => {
  const folderPath = path.resolve(__dirname, folderName);

  fs.readdirSync(folderPath).forEach((item) => {
    fs.renameSync(
      path.resolve(folderPath, item),
      path.resolve(
        folderPath,
        item.replace(new RegExp(`^${oldPrefix}`), newPrefix)
      )
    );
  });
};

const folderName = "qq";
const oldPrefix = "qq-";
const newPrefix = "qq_";

rename(folderName, oldPrefix, newPrefix);
