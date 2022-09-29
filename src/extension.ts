import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

import * as express from 'express';
import cors = require('cors');

const PORT = 30001;


// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext)
{
    // Spawn simple server
    const app = express();
    app.use(cors())
    const expressStaticPath = path.join(context.extensionPath, 'webview', 'build')
    console.log("expressStaticPath", expressStaticPath)

    if (false)
    {
        app.use(express.static(expressStaticPath))
    }
    else
    {
        console.log("Not serving static for DEV")
    }

    app.get("/api/open", (req, res) =>
    {
        console.log("/api/open", req.query)
        const file = req.query.file
        const section = String(req.query.section)

        const folder = vscode.workspace.workspaceFolders

        if (folder && folder.length > 0) {
           
            const target = vscode.Uri.file(folder[0].uri.fsPath + "/VBSD.VBS.RND.SRC/" + file)
            console.log("opening", target)
            vscode.workspace.openTextDocument(target).then(doc =>
            {
                vscode.window.showTextDocument(doc, vscode.ViewColumn.One).then(editor => 
                {
                    console.log("opened", file)

                    const lines = editor.document.getText().split("\n")

                    for (let index = 0; index < lines.length; index++) {
                        const element = lines[index];
                        if (element.includes(section))
                        {
                            const positionStart = new vscode.Position(index, 0)
                            const positionEnd = new vscode.Position(index + 10, 0)
                            editor.revealRange(new vscode.Range(positionStart, positionEnd))
                            break
                        }
                    }
                });
            })
        }

        res.send()
    })

    app.listen(PORT)
    
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    console.log('Congratulations, your extension "cobam" is now active!');
    vscode.window.showInformationMessage('Activated Cobam!');

    // The command has been defined in the package.json file
    // Now provide the implementation of the command with registerCommand
    // The commandId parameter must match the command field in package.json
    const commandHello = vscode.commands.registerCommand('extension.helloCobam', () =>
    {
        // The code you place here will be executed every time your command is executed
        const msg = 'Hello Cobam! 2';

        // Display a message box to the user
        vscode.window.showInformationMessage(msg);
    });

    context.subscriptions.push(commandHello);

    context.subscriptions.push(
        vscode.commands.registerCommand('extension.visualiseCodebase', () =>
        {
            const resourceRoot = vscode.Uri.file(path.join(context.extensionPath, 'webview'))

            console.log("webview root", resourceRoot)
            // Create and show a new webview
            const panel = vscode.window.createWebviewPanel(
                'cobam', // Identifies the type of the webview. Used internally
                'Codebase Visualisation', // Title of the panel displayed to the user
                vscode.ViewColumn.Two, // Editor column to show the new webview panel in.
                {
                    enableScripts: true,
                    localResourceRoots: [resourceRoot],
                    portMapping: [
                        { webviewPort: PORT, extensionHostPort: PORT }
                    ]
                } // Webview options. More on these later.
            );

            const htmlPathOnDisk = vscode.Uri.file(path.join(context.extensionPath, 'webview', 'index.html'));

            var html = fs.readFileSync(htmlPathOnDisk.fsPath).toString();

            panel.webview.html = html
        })
    );
}
