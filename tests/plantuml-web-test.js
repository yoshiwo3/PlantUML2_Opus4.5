// PlantUML Web Editor Test Script
const { chromium } = require('playwright');
const path = require('path');

async function testPlantUMLWebEditor() {
    const screenshotDir = path.join(__dirname, '..', 'docs', 'evidence', '20251207_playwright_test');

    console.log('Starting PlantUML Web Editor test...');
    console.log('Screenshot directory:', screenshotDir);

    // Launch browser
    const browser = await chromium.launch({
        headless: true
    });

    const context = await browser.newContext({
        viewport: { width: 1920, height: 1080 }
    });

    const page = await context.newPage();

    try {
        // Step 1: Navigate to PlantUML web editor
        console.log('\n[Step 1] Navigating to http://www.plantuml.com/plantuml/uml/');
        await page.goto('http://www.plantuml.com/plantuml/uml/', {
            waitUntil: 'networkidle',
            timeout: 30000
        });
        console.log('Navigation successful');

        // Step 2: Take initial snapshot
        console.log('\n[Step 2] Taking initial screenshot...');
        await page.screenshot({
            path: path.join(screenshotDir, '01_initial_page.png'),
            fullPage: true
        });
        console.log('Initial screenshot saved');

        // Step 3: Analyze page structure
        console.log('\n[Step 3] Analyzing page structure...');

        // Check for textarea with id="inflated"
        const inflatedTextarea = await page.$('#inflated');
        console.log('textarea#inflated found:', !!inflatedTextarea);

        // Check for other possible input elements
        const textareas = await page.$$('textarea');
        console.log('Total textareas found:', textareas.length);

        for (let i = 0; i < textareas.length; i++) {
            const ta = textareas[i];
            const id = await ta.getAttribute('id');
            const name = await ta.getAttribute('name');
            const className = await ta.getAttribute('class');
            const isVisible = await ta.isVisible();
            console.log(`  Textarea ${i}: id="${id}", name="${name}", class="${className}", visible=${isVisible}`);
        }

        // Check for CodeMirror or Monaco editor
        const codeMirror = await page.$('.CodeMirror');
        const monacoEditor = await page.$('.monaco-editor');
        console.log('CodeMirror editor found:', !!codeMirror);
        console.log('Monaco editor found:', !!monacoEditor);

        // Step 4: Input PlantUML code
        console.log('\n[Step 4] Inputting PlantUML code...');

        const testCode = `@startuml
Alice -> Bob : Hello
Bob -> Alice : Hi there
@enduml`;

        let inputSelector = null;

        // Try different input methods
        if (inflatedTextarea && await inflatedTextarea.isVisible()) {
            inputSelector = '#inflated';
            console.log('Using #inflated textarea');

            // Clear existing content and input new code
            await page.fill(inputSelector, '');
            await page.fill(inputSelector, testCode);
        } else if (codeMirror) {
            console.log('Using CodeMirror editor');
            inputSelector = '.CodeMirror';

            // For CodeMirror, we need to click and type
            await codeMirror.click();
            await page.keyboard.press('Control+A');
            await page.keyboard.type(testCode);
        } else {
            // Try to find any visible textarea
            const visibleTextarea = await page.$('textarea:visible');
            if (visibleTextarea) {
                const id = await visibleTextarea.getAttribute('id');
                inputSelector = id ? `#${id}` : 'textarea';
                console.log('Using visible textarea:', inputSelector);
                await page.fill(inputSelector, testCode);
            } else {
                throw new Error('No suitable input element found');
            }
        }

        console.log('Code input successful');
        console.log('Input selector used:', inputSelector);

        // Step 5: Wait for auto-refresh
        console.log('\n[Step 5] Waiting 3 seconds for auto-refresh...');
        await page.waitForTimeout(3000);

        // Step 6: Take screenshot of rendered diagram
        console.log('\n[Step 6] Taking screenshot of rendered diagram...');
        await page.screenshot({
            path: path.join(screenshotDir, '02_rendered_diagram.png'),
            fullPage: true
        });
        console.log('Final screenshot saved');

        // Check for rendered image
        const diagramImg = await page.$('img[alt="PlantUML diagram"]') ||
                          await page.$('#diagram img') ||
                          await page.$('img[src*="plantuml"]');

        if (diagramImg) {
            const src = await diagramImg.getAttribute('src');
            console.log('\nRendered diagram image found');
            console.log('Image source:', src ? src.substring(0, 100) + '...' : 'N/A');
        } else {
            console.log('\nWarning: Could not locate diagram image element');
        }

        // Summary
        console.log('\n========================================');
        console.log('TEST RESULT: SUCCESS');
        console.log('========================================');
        console.log('Input selector:', inputSelector);
        console.log('Screenshots saved to:', screenshotDir);
        console.log('  - 01_initial_page.png');
        console.log('  - 02_rendered_diagram.png');

        return {
            success: true,
            inputSelector: inputSelector,
            screenshotDir: screenshotDir
        };

    } catch (error) {
        console.error('\n========================================');
        console.error('TEST RESULT: FAILED');
        console.error('========================================');
        console.error('Error:', error.message);

        // Take error screenshot
        try {
            await page.screenshot({
                path: path.join(screenshotDir, 'error_screenshot.png'),
                fullPage: true
            });
            console.log('Error screenshot saved');
        } catch (e) {
            console.error('Could not save error screenshot');
        }

        return {
            success: false,
            error: error.message
        };

    } finally {
        await browser.close();
        console.log('\nBrowser closed');
    }
}

// Run the test
testPlantUMLWebEditor().then(result => {
    console.log('\nFinal result:', JSON.stringify(result, null, 2));
    process.exit(result.success ? 0 : 1);
}).catch(err => {
    console.error('Unexpected error:', err);
    process.exit(1);
});
