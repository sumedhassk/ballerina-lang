/**
 * Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */


import React from 'react';
import _ from 'lodash';
import PropTypes from 'prop-types';
import ExpressionEditor from 'plugins/ballerina/expression-editor/expression-editor-utils';
import SimpleBBox from './../../../../../model/view/simple-bounding-box';
import { lifeLine } from './../../designer-defaults';
import * as DesignerDefaults from './../../designer-defaults';
import TreeUtils from './../../../../../model/tree-util';
import OverlayComponentsRenderingUtil from './../utils/overlay-component-rendering-util';
import ActionBox from './action-box';
import ActiveArbiter from './active-arbiter';

class Client extends React.Component {

    constructor(props) {
        super(props);
    }

    render() {
        const bBox = this.props.bBox;
        const topBox = Object.assign({}, bBox);
        const bottomBox = Object.assign({}, bBox);

        const header = 40;
        bottomBox.h = lifeLine.head.height;
        topBox.h = lifeLine.head.height;

        bottomBox.y = bBox.y + bBox.h - bottomBox.h;

        // calculate the line coordinates
        const line = {};
        line.x1 = (header / 2) + bBox.x;
        line.x2 = (header / 2) + bBox.x;
        line.y1 = bBox.y;
        line.y2 = bBox.y + bBox.h;

        const invokeLineY = topBox.y + topBox.h + this.context.designer.config.statement.height;

        return (<g
            className='client-line-group'
        >
            <line
                x1={line.x1}
                y1={line.y1}
                x2={line.x2}
                y2={line.y2}
                className='client-life-line unhoverable'
            />
            <rect
                x={topBox.x}
                y={topBox.y}
                width={header}
                height={header}
                rx='3'
                ry='3'
                className='client-line-header'
                transform={`translate(${header / 2} -${header / 2}) rotate(45 ${topBox.x} ${topBox.y})`}
            />
            <rect
                x={bottomBox.x}
                y={bottomBox.y}
                width={header}
                height={header}
                rx='3'
                ry='3'
                className='client-line-header'
                transform={`translate(${header / 2}) rotate(45 ${bottomBox.x} ${bottomBox.y})`}
            />
            <text
                x={topBox.x + 10}
                y={topBox.y + 10}

                dominantBaseline='central'
                className='client-line-text genericT'
            >{this.props.title}</text>
            <text
                x={bottomBox.x + 10}
                y={bottomBox.y + 30}

                dominantBaseline='central'
                className='client-line-text genericT'
            >{this.props.title}</text>
            <line
                x1={line.x1}
                y1={invokeLineY}
                x2={bBox.arrowLine}
                y2={invokeLineY}
                stroke='black'
                strokeWidth='1'
            />
            <text
                x={line.x1 + this.context.designer.config.statement.gutter.h}
                y={topBox.y + topBox.h + (this.context.designer.config.statement.height / 2)}
                dominantBaseline='central'
                className='client-line-text genericT'
            >{bBox.text}</text>
        </g>);
    }
}

Client.propTypes = {
    editorOptions: PropTypes.shape(),
};

Client.defaultProps = {
    editorOptions: null,
};

Client.contextTypes = {
    model: PropTypes.instanceOf(Object),
    designer: PropTypes.instanceOf(Object),
};

export default Client;
