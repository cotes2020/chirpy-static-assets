const fs = require("fs");
const path = require("path");
const { exit } = require("process");

const exludeFolders = [".git", ".github"];
const imageExtensions = [".png", ".gif", ".webp"];

try {
  fs
    // get folders
    .readdirSync("./", { withFileTypes: true })
    // filter to get emojiFolders
    .filter((item) => item.isDirectory() && !exludeFolders.includes(item.name))
    // get folder name
    .map((item) => item.name)
    // return a promise handling emojis
    .forEach((folderName) => {
      const folderPath = path.resolve(__dirname, folderName);
      const infoPath = path.resolve(folderPath, "info.json");

      // test if info file exists
      if (!fs.existsSync(infoPath))
        throw new Error(`Info File in ${folderPath} is missing`);

      // parse info
      const info = JSON.parse(fs.readFileSync(infoPath, { encoding: "utf-8" }));

      const images =
        // read emoji dir
        fs
          .readdirSync(folderPath, { withFileTypes: true })
          // filter to get image files
          .filter(
            (item) =>
              item.isFile() && imageExtensions.includes(path.extname(item.name))
          )
          // get image name
          .map((item) => item.name);
      const { prefix, type } = info;

      // check if the given info is valid
      if (
        typeof info.name !== "string" ||
        !info.name ||
        info.items.some((item) =>
          item.includes(`${prefix}${info.name}.${type}`)
        )
      )
        throw new Error(`Field "name" is invalid in ${folderPath} info file.`);
      if (!images.every((item) => item.startsWith(prefix)))
        throw new Error(
          `Field "prefix" is invalid in ${folderPath} info file.`
        );
      if (!images.every((item) => item.endsWith(type)))
        throw new Error(`Field "type" is invalid in ${folderPath} info file.`);
      if (!Array.isArray(info.items))
        throw new Error(`Field "items" is invalid in ${folderPath} info file.`);

      const items = images.map((item) =>
        item
          // remove prefix
          .replace(new RegExp(`^${prefix}`), "")
          // remove type
          .replace(new RegExp(`\.${type}$`), "")
      );

      info.items = Array.from(
        new Set([
          // filter old emojis and remain existing ones
          ...info.items.filter((item) => items.includes(item)),
          ...items,
        ])
      );

      // update info
      fs.writeFileSync(infoPath, JSON.stringify(info), { encoding: "utf-8" });
    });
} catch (err) {
  console.error("Process end with error:", err);
  exit(1);
}
