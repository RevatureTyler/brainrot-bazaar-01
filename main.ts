// Hands the Brainrot Bazaar entry in: copies the built place, the source, the screenshots and PLAY.json
// to the output folder, then writes dossier.json with the vendored make.fun library.
//
// Outside the grader's container, MAKEFUN_OUTPUT_DIR stands in for /output:
//   mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts

import { copyFileSync, cpSync, existsSync, mkdirSync, readdirSync, statSync, writeFileSync } from 'node:fs';
import { basename, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildDossier } from './vendor/makefun-roblox.ts';

const repo = fileURLToPath(new URL('.', import.meta.url));
const output = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

const SCREENSHOT_MIN = 3;
const SCREENSHOT_MAX = 4;
const SCREENSHOT_MAX_BYTES = 256 * 1024;

// Names starting with a dot never reach the output: .gitkeep, .DS_Store and .git stay out at any depth.
const withoutDotNames = (path: string): boolean => !basename(path).startsWith('.');

function requireFile(path: string): void {
  if (!existsSync(path)) {
    throw new Error(`missing ${path}: build game.rbxl and write PLAY.json before handing in`);
  }
}

function checkScreenshots(dir: string): void {
  const names = readdirSync(dir).filter(withoutDotNames);
  if (names.length < SCREENSHOT_MIN || names.length > SCREENSHOT_MAX) {
    throw new Error(`screenshots/ holds ${names.length} files; hand in ${SCREENSHOT_MIN} to ${SCREENSHOT_MAX}`);
  }
  for (const name of names) {
    const size = statSync(join(dir, name)).size;
    if (size > SCREENSHOT_MAX_BYTES) {
      throw new Error(`${name} is ${size} bytes; each screenshot must be at most ${SCREENSHOT_MAX_BYTES}`);
    }
  }
}

requireFile(join(repo, 'game.rbxl'));
requireFile(join(repo, 'PLAY.json'));
checkScreenshots(join(repo, 'screenshots'));

mkdirSync(output, { recursive: true });
copyFileSync(join(repo, 'game.rbxl'), join(output, 'game.rbxl'));
copyFileSync(join(repo, 'PLAY.json'), join(output, 'PLAY.json'));
cpSync(join(repo, 'src'), join(output, 'src'), { recursive: true, filter: withoutDotNames });
mkdirSync(join(output, 'screenshots'), { recursive: true });
cpSync(join(repo, 'screenshots'), join(output, 'screenshots'), { recursive: true, filter: withoutDotNames });

const dossier = buildDossier(output, {
  text_max_bytes: 65536,
  screenshots: { max: SCREENSHOT_MAX, max_bytes: SCREENSHOT_MAX_BYTES },
  max_instances: 500000,
  scripts_max_source_bytes: 8388608,
  scripts_max_path_chars: 1048576,
});
writeFileSync(join(output, 'dossier.json'), dossier);
console.log(`handed in to ${output}: dossier.json ${dossier.length} bytes`);
