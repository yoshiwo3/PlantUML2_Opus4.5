/**
 * WF統合スクリプト
 * 07_gui_panel_quick_add.excalidrawのMode 1要素を01_defaultに統合
 * 07のMode 2要素から06_gui_onlyを新規作成
 */

const fs = require('fs');
const path = require('path');

const BASE_DIR = path.join(__dirname, '..', 'docs', 'evidence', '20251224_1955_ui_design_login', 'wireframes', '04_editor');

// ファイルパス
const FILE_07 = path.join(BASE_DIR, '07_gui_panel_quick_add.excalidraw');
const FILE_01 = path.join(BASE_DIR, '01_default.excalidraw');
const FILE_06 = path.join(BASE_DIR, '06_gui_only.excalidraw');

// Mode 1要素のIDプレフィックス
const MODE1_PREFIX = 'mode1-';
const MODE2_PREFIX = 'mode2-';

function loadExcalidraw(filePath) {
    const content = fs.readFileSync(filePath, 'utf8');
    return JSON.parse(content);
}

function saveExcalidraw(filePath, data) {
    fs.writeFileSync(filePath, JSON.stringify(data, null, '\t'), 'utf8');
}

function filterElementsByPrefix(elements, prefix) {
    return elements.filter(el => el.id && el.id.startsWith(prefix));
}

function filterElementsByXRange(elements, minX, maxX) {
    return elements.filter(el => {
        const x = el.x || 0;
        return x >= minX && x <= maxX;
    });
}

function shiftElements(elements, deltaX, deltaY) {
    return elements.map(el => {
        const newEl = { ...el };
        if (typeof newEl.x === 'number') newEl.x += deltaX;
        if (typeof newEl.y === 'number') newEl.y += deltaY;
        // Update version to avoid conflicts
        newEl.version = (newEl.version || 1) + 1;
        newEl.versionNonce = Date.now() + Math.floor(Math.random() * 10000);
        return newEl;
    });
}

function renameElementIds(elements, prefix) {
    const idMap = new Map();

    return elements.map(el => {
        const newEl = { ...el };
        const oldId = el.id;
        const newId = prefix + oldId;
        idMap.set(oldId, newId);
        newEl.id = newId;

        // Update containerId if exists
        if (newEl.containerId && idMap.has(newEl.containerId)) {
            newEl.containerId = idMap.get(newEl.containerId);
        }

        // Update boundElements if exists
        if (newEl.boundElements && Array.isArray(newEl.boundElements)) {
            newEl.boundElements = newEl.boundElements.map(be => {
                if (idMap.has(be.id)) {
                    return { ...be, id: idMap.get(be.id) };
                }
                return be;
            });
        }

        // Update groupIds if exists
        if (newEl.groupIds && Array.isArray(newEl.groupIds)) {
            newEl.groupIds = newEl.groupIds.map(gid => {
                if (idMap.has(gid)) {
                    return idMap.get(gid);
                }
                return prefix + gid;
            });
        }

        return newEl;
    });
}

function integrateMode1To01Default() {
    console.log('=== Phase 2: 01_default統合 ===');

    // Load files
    const data07 = loadExcalidraw(FILE_07);
    const data01 = loadExcalidraw(FILE_01);

    console.log(`07 elements count: ${data07.elements.length}`);
    console.log(`01 elements count: ${data01.elements.length}`);

    // Filter Mode 1 elements from 07
    const mode1Elements = filterElementsByPrefix(data07.elements, MODE1_PREFIX);
    console.log(`Mode 1 elements found: ${mode1Elements.length}`);

    // Also get related text elements (labels inside forms)
    const mode1Area = filterElementsByXRange(data07.elements, 0, 350);
    const mode1TextElements = mode1Area.filter(el =>
        el.type === 'text' &&
        !el.id.startsWith(MODE1_PREFIX) &&
        !el.id.startsWith(MODE2_PREFIX) &&
        el.y > 0 && el.y < 650
    );
    console.log(`Mode 1 text elements found: ${mode1TextElements.length}`);

    // Combine Mode 1 elements
    const allMode1Elements = [...mode1Elements, ...mode1TextElements];

    // Rename IDs to avoid conflicts
    const renamedElements = renameElementIds(allMode1Elements, 'integrated_');

    // Shift coordinates to fit in 01_default GUIパネル
    // 07のMode 1: x=20〜320, y=20〜600
    // 01_defaultのGUIパネル: x=0〜300, y=48〜880
    // オフセット: x-20, y+48 (Section 2開始位置に合わせる)
    const shiftedElements = shiftElements(renamedElements, -12, 200);

    // Add to 01_default
    data01.elements = [...data01.elements, ...shiftedElements];

    // Backup original
    const backupPath = FILE_01.replace('.excalidraw', '_before_integration.excalidraw');
    fs.copyFileSync(FILE_01, backupPath);
    console.log(`Backup created: ${backupPath}`);

    // Save integrated file
    saveExcalidraw(FILE_01, data01);
    console.log(`Integrated 01_default saved. New element count: ${data01.elements.length}`);

    return shiftedElements.length;
}

function createMode2As06GuiOnly() {
    console.log('\n=== Phase 3: 06_gui_only作成 ===');

    // Load 07
    const data07 = loadExcalidraw(FILE_07);

    // Filter Mode 2 elements from 07
    const mode2Elements = filterElementsByPrefix(data07.elements, MODE2_PREFIX);
    console.log(`Mode 2 elements found: ${mode2Elements.length}`);

    // Also get related text elements
    const mode2Area = filterElementsByXRange(data07.elements, 350, 1000);
    const mode2TextElements = mode2Area.filter(el =>
        el.type === 'text' &&
        !el.id.startsWith(MODE1_PREFIX) &&
        !el.id.startsWith(MODE2_PREFIX) &&
        el.y > 0 && el.y < 450
    );
    console.log(`Mode 2 text elements found: ${mode2TextElements.length}`);

    // Combine Mode 2 elements
    const allMode2Elements = [...mode2Elements, ...mode2TextElements];

    // Shift coordinates to (0,0) origin
    // 07のMode 2: x=370〜970, y=20〜380
    // オフセット: x-370, y-20
    const shiftedElements = shiftElements(allMode2Elements, -370, -20);

    // Create new Excalidraw file structure
    const data06 = {
        type: "excalidraw",
        version: 2,
        source: "https://github.com/zsviczian/obsidian-excalidraw-plugin",
        elements: shiftedElements,
        appState: {
            gridSize: null,
            viewBackgroundColor: "#ffffff"
        },
        files: {}
    };

    // Add title text
    const titleElement = {
        id: "gui_only_title",
        type: "text",
        x: 0,
        y: -40,
        width: 400,
        height: 25,
        text: "06_gui_only - Mode 2 (950px) GUIパネル拡張表示",
        fontSize: 20,
        fontFamily: 1,
        textAlign: "left",
        verticalAlign: "top",
        strokeColor: "#1e1e1e",
        backgroundColor: "transparent",
        fillStyle: "solid",
        strokeWidth: 1,
        strokeStyle: "solid",
        roughness: 1,
        opacity: 100,
        version: 1,
        versionNonce: Date.now(),
        isDeleted: false,
        groupIds: [],
        frameId: null,
        roundness: null,
        boundElements: [],
        updated: Date.now(),
        link: null,
        locked: false
    };

    data06.elements.unshift(titleElement);

    // Save 06_gui_only
    saveExcalidraw(FILE_06, data06);
    console.log(`06_gui_only created. Element count: ${data06.elements.length}`);

    return data06.elements.length;
}

// Main execution
console.log('WF統合スクリプト開始\n');
console.log(`Base directory: ${BASE_DIR}\n`);

try {
    const integrated01Count = integrateMode1To01Default();
    const created06Count = createMode2As06GuiOnly();

    console.log('\n=== 統合完了 ===');
    console.log(`01_default: ${integrated01Count} 要素追加`);
    console.log(`06_gui_only: ${created06Count} 要素で新規作成`);
    console.log('\n次のステップ:');
    console.log('1. Excalidrawで01_default.excalidrawを開いて視覚確認');
    console.log('2. Excalidrawで06_gui_only.excalidrawを開いて視覚確認');
    console.log('3. 00_wireframe_index.mdを更新');
} catch (error) {
    console.error('エラー:', error.message);
    process.exit(1);
}
