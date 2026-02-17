/**
 * This script is used to update the version in the fxmanifest.lua file when a new release is created.
 * Adapted from ox_lib (https://github.com/overextended/ox_lib)
 * This file is licensed under LGPL-3.0: https://www.gnu.org/licenses/lgpl-3.0.html
 * and is used under the same license.
 */
const fs = require("fs");
const path = require("path");

const version = process.env.TGT_RELEASE_VERSION;
if (!version) {
  console.error("TGT_RELEASE_VERSION is not set.");
  process.exit(1);
}

const newVersion = version.replace("v", "");
console.log(`Bumping version to ${newVersion}`);

// Update fxmanifest.lua
const manifestFile = fs.readFileSync("fxmanifest.lua", { encoding: "utf8" });
const newManifestContent = manifestFile.replace(
  /\bversion\s+(.*)$/gm,
  `version '${newVersion}'`,
);
fs.writeFileSync("fxmanifest.lua", newManifestContent);
console.log("Updated fxmanifest.lua");

// Update web/package.json
const packageJsonPath = path.join("web", "package.json");
const packageJson = JSON.parse(
  fs.readFileSync(packageJsonPath, { encoding: "utf8" }),
);
packageJson.version = newVersion;
fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2) + "\n");
console.log("Updated web/package.json");
