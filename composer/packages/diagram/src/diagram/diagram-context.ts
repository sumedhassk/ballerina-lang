import { ASTNode } from "@ballerina/ast-model";
import { IBallerinaLangClient } from "@ballerina/lang-service";
import React from "react";
import { DefaultConfig } from "../config/default";

export enum DiagramMode { ACTION, DEFAULT }

export interface IDiagramContext {
    ast: ASTNode | undefined;
    changeMode: (newMode: DiagramMode) => void;
    editingEnabled: boolean;
    mode: DiagramMode;
    toggleEditing: () => void;
    diagramHeight: number;
    diagramWidth: number;
    zoomIn: () => void;
    zoomOut: () => void;
    zoomFit: () => void;
    langClient?: IBallerinaLangClient;
    overlayGroupRef?: React.RefObject<SVGGElement>;
    containerRef?: React.RefObject<HTMLDivElement>;
}

const defaultDiagramContext: IDiagramContext = {
    ast: undefined,
    changeMode: () => {
        // do nothing
    },
    diagramHeight: DefaultConfig.canvas.height,
    diagramWidth: DefaultConfig.canvas.width,
    editingEnabled: false,
    mode: DiagramMode.ACTION,
    toggleEditing: () => {
        // do nothing
    },
    zoomFit: () => {
        // do nothing
    },
    zoomIn: () => {
        // do nothing
    },
    zoomOut: () => {
        // do nothing
    },
};

export const DiagramContext = React.createContext(defaultDiagramContext);
